# == Schema Information
# Schema version: 20101119035757
#
# Table name: twitter_accounts
#
#  id             :integer         not null, primary key
#  account_type   :string(255)     default("TwitterAccount")
#  person_id      :integer
#  last_sync_time :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  unique_id      :string(255)
#  login          :string(255)
#  oauth_token    :string(255)
#  oauth_secret   :string(255)
#

require 'oauth'
require 'model_mixins/account_properties'
require 'connection'

class TwitterAccount < ActiveRecord::Base
  include AccountProperties

  # Accessors
  attr_accessible :unique_id, :login

  # Validation
  validates :unique_id, :uniqueness => true,
    :presence => true

  def authorized?
    !oauth_token.blank? && !oauth_secret.blank?
  end

  def authorize(rtoken, rsecret, options = {})
    request_token = OAuth::RequestToken.new(
      consumer, rtoken, rsecret
    )
    access_token = request_token.get_access_token(options)
    self.oauth_token = access_token.token
    self.oauth_secret = access_token.secret
    access_token
  end

  def request_token(options = {})
    consumer.get_request_token(options)
  end

  def consumer
    @consumer ||= begin
                    options = {:site => @@config["site"], :request_endpoint => @@config["site"]}
                    OAuth::Consumer.new(@@config["consumer_token"],
                                        @@config["consumer_secret"],
                                        options)
                  end
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

    # Friend relationships
    friends = client.friends
    old_connection_count = person.connections.length

    logger.debug "Twitter Sync: Start #{friends.length} Twitter accounts for Person #{person.id}"

    # Add each friend to the database
    friends.each do |friend| 
      # Check if in DB or create
      friend_account = find_or_create(:unique_id, {:unique_id => friend.id_str, :login => friend.screen_name})

      # Check if they are connected already or create the connection
      connection = FriendConnection.find_or_create(person.id, friend_account.person.id)
    end

    # NOTE: Need to remove connections that are no longer relevant

    # Force a query to the DB again
    # Probably want to remove this in the future for performance
    new_connection_count = person.connections(true).length
    connection_delta = new_connection_count - old_connection_count

    logger.debug "Twitter Sync: Complete #{connection_delta} new connections, before #{old_connection_count} after #{new_connection_count}"
  end

  def client
    return nil if !authorized?
    @client ||= begin
                  Twitter.configure do |config|
                    config.consumer_key = @@config["consumer_token"]
                    config.consumer_secret = @@config["consumer_secret"]
                    config.oauth_token = oauth_token
                    config.oauth_token_secret = oauth_secret
                  end
                  Twitter::Client.new
                end
  end

  def self.config
    @@config 
  end

  @@config = YAML::load(File.open("#{::Rails.root.to_s}/config/twitter.yml"))

end
