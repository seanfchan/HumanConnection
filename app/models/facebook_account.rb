# == Schema Information
# Schema version: 20101119035757
#
# Table name: facebook_accounts
#
#  id             :integer         not null, primary key
#  person_id      :integer
#  last_sync_time :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  unique_id      :string(255)
#  oauth_token    :string(255)
#

require 'oauth'
require 'model_mixins/account_properties'
require 'connection'

class FacebookAccount < ActiveRecord::Base
  include AccountProperties
  
  # Accessors
  attr_accessible :unique_id
  
  # Validation
  validates :unique_id, :presence => true, 
                        :uniqueness => true

  def authorized?
    !oauth_token.blank?
  end

  def authorize(code, options = {})
    access_token = client.authorization.process_callback(code, options)
    self.oauth_token = access_token
    access_token
  end

  # Returns an existing account if found
  def existing
    return self.class.find_by_unique_id(unique_id)
  end

  def mergeable(other)
    return unique_id == other.unique_id
  end

  def sync_contacts
    # Check against ActiveRecord validators
    return if !(valid? || authorized?)

    friends = client.selection.me.friends.info!
    data = friends.data

    logger.debug "Syncing #{data.length} Facebook accounts for Person #{person.id}"
    new_accounts, new_people = 0, 0

    # Add each friend to the database
    data.each do |friend| 
    
      # Check if they are already in the DB
      friend_account = self.class.find_by_unique_id(friend.id)
      
      # Add a Facebook account and person to the DB
      if !friend_account
        # Create a person
        friend_person = Person.new
        friend_person.save

        # Create a Facebook account
        friend_account = FacebookAccount.new
        friend_account.unique_id = friend.id
        friend_person.facebook_accounts << friend_account

        new_people += 1
        new_accounts += 1
      end

      # NOTE: Need to check for family relationships to create FamilyConnection instead

      # Check if they are connected already or create the connection
      connection = FriendConnection.find_or_create(person.id, friend_account.person.id)
    end

    logger.debug "After sync: #{new_accounts} facebook accounts, #{new_people} new persons"

  end

  def client
    @client ||= FBGraph::Client.new(:client_id => @@config["app_id"],
                                    :secret_id => @@config["app_secret"],
                                    :token => oauth_token)
  end

  def self.config
    @@config
  end

  @@config = YAML::load(File.open("#{::Rails.root.to_s}/config/facebook.yml"))

end
