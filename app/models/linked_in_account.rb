# == Schema Information
# Schema version: 20101119035757
#
# Table name: linked_in_accounts
#
#  id             :integer         not null, primary key
#  account_type   :string(255)     default("LinkedInAccount")
#  person_id      :integer
#  last_sync_time :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  unique_id      :string(255)
#  oauth_token    :string(255)
#  oauth_secret   :string(255)
#

require 'model_mixins/account_properties'

class LinkedInAccount < ActiveRecord::Base
  include AccountProperties

  # Accessors
  attr_accessible :unique_id

  # Validation
  validates :unique_id, :uniqueness => true,
    :presence => true

  def authorized?
    !oauth_token.blank? && !oauth_secret.blank?
  end

  def authorize(rtoken, rsecret, oauth_verifier)
    access_token = client.authorize_from_request(rtoken, rsecret, oauth_verifier)
    self.oauth_token = access_token[0]
    self.oauth_secret = access_token[1]
    access_token
  end

  # Returns an existing account if found
  def existing
    return self.class.find_by_unique_id(unique_id)
  end

  def mergeable(other)
    return unique_id == other.unique_id
  end

  def find_or_create(uniq_id)
    # Check if they are already in the DB
    friend_account = self.class.find_by_unique_id(uniq_id)

    # Add a Facebook account and person to the DB
    if !friend_account
      # Create a person
      friend_person = Person.new
      friend_person.save

      # Create a LinkedIn account
      friend_account = self.class.new
      friend_account.unique_id = uniq_id
      friend_person.linked_in_accounts << friend_account
    end
    friend_account
  end

  def sync_contacts
    # Check against ActiveRecord validators
    return if !(valid? || authorized?)

    old_connection_count = person.connections.length

    # Friend relationships
    friends = client.connections

    logger.debug "LinkedIn Sync: Start #{friends.length} LinkedIn accounts for Person #{person.id}"
    
    # Add each friend to the database
    friends.each do |friend| 
      # Check if in DB or create
      friend_account = find_or_create(friend.id)

      # Check if they are connected already or create the connection
      connection = FriendConnection.find_or_create(person.id, friend_account.person.id)
    end

    # NOTE: Need to remove connections that are no longer relevant

    # Force a query to the DB again
    # Probably want to remove this in the future for performance
    new_connection_count = person.connections(true).length
    connection_delta = new_connection_count - old_connection_count

    logger.debug "LinkedIn Sync: Complete #{connection_delta} new connections, before #{old_connection_count} after #{new_connection_count}"
  end

  def client
    @client ||= LinkedIn::Client::new(@@config["consumer_token"],
                                      @@config["consumer_secret"])
    if authorized?
      @client.authorize_from_access(oauth_token, oauth_secret)
    end
    @client
  end

  def self.config
    @@config 
  end

  @@config = YAML::load(File.open("#{::Rails.root.to_s}/config/linkedin.yml"))

end
