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

# File::      twitter_account.rb
#
# Author::    Jon Boekenoogen (mailto:jboekeno@gmail.com)
# Copyright:: Copyright (c) 2010 <INSERT_COMPANY_NAME>

require 'oauth'
require 'model_mixins/account_properties'
require 'connection'

# This class represents a Twitter Account in the database. 
class TwitterAccount < ActiveRecord::Base
  include AccountProperties

  # Accessors
  attr_accessible :unique_id, :login

  # Validation
  validates :unique_id, :uniqueness => true,
    :presence => true

  # Performs a quick check whether this account could
  # be valid. Really need to double check with api requests.
  # === Return
  # true if could be valid, false otherwise
  def authorized?
    !oauth_token.blank? && !oauth_secret.blank?
  end

  # Sets the oauth_token and oauth_secret for an account.
  # This is done by asking Twitter for the access token given the
  # request token values.
  # === Parameters
  # * +rtoken+ - Request token obtained previously from request_token
  # * +rsecret+ - Request secret obtained previously from request_token
  # * +options+ - Html options that are required by Twitter API. None for now
  # === Return
  # access token from Twitter
  def authorize(rtoken, rsecret, options = {})
    # Create request_token using old values
    request_token = OAuth::RequestToken.new(
      consumer, rtoken, rsecret
    )
    access_token = request_token.get_access_token(options)
    self.oauth_token = access_token.token
    self.oauth_secret = access_token.secret
    access_token
  end

  # Gets a request_token from Twitter 
  # === Parameters
  # * +options+ - Html options that are required by Twitter API. None for now
  # === Return
  # request token from Twitter
  def request_token(options = {})
    consumer.get_request_token(options)
  end

  # Creates a consumer object and caches it for OAuth plugin using
  # Twitter API configuration
  # === Return
  # Consumer from OAuth plugin.
  def consumer
    @consumer ||= begin
                    options = {:site => @@config["site"], :request_endpoint => @@config["site"]}
                    OAuth::Consumer.new(@@config["consumer_token"],
                                        @@config["consumer_secret"],
                                        options)
                  end
  end

  # Finds an existing TwitterAccount using unique_id of self
  # === Return
  # Existing account if found, nil otherwise
  def existing
    return self.class.find_by_unique_id(unique_id)
  end
  
  # Checks whether this account and another can be merged 
  # === Parameters
  # * +other+ - other object to be merged with
  # === Return
  # true if mergeable, false otherwise
  def mergeable(other)
    return self.class == other.class && unique_id == other.unique_id
  end
  
  # Accesses TwitterApi and populates contact information into the database.
  # TODO: Remove connections if no longer friends under any accounts.
  # 
  # === Steps:
  # * Check if account is valid.
  # * Download followers.
  # * Add follower as Person/TwitterAccount if not in DB.
  # * Add follower as connection if not in DB.
  # === Return
  # None
  def sync_contacts
    # Check against ActiveRecord validators
    return if !(valid? || authorized?)

    # Friend relationships
    # Wrap in exception in case access has been revoked
    begin
      friends = client.friends
    rescue
      # Nothing we can really do here. So just return. 
      # We need to check these on startup and prompt the user to either
      # delete their Twitter account or grant access again.
      logger.debug "Twitter access for person #{person.id if person} has been revoked"
      return
    end

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

  # Main access point for the Twitter api. Use this object for all api
  # interactions. Client is cached until forced to reload
  # === Parameters
  # * +force+ - Force a reload on the client.
  # === Return
  # Twitter client to use for api access, nil if not authorized
  def client(force = false)
    return @client = nil if !authorized?
    
    if force || !@client
      Twitter.configure do |config|
        config.consumer_key = @@config["consumer_token"]
        config.consumer_secret = @@config["consumer_secret"]
        config.oauth_token = oauth_token
        config.oauth_token_secret = oauth_secret
      end
      @client = Twitter::Client.new
    end
    
    @client
  end
  
  # Convenience method to accessing configuration parameters
  # === Returns
  # Twitter configuration as a yaml hash
  def self.config
    @@config 
  end

  # Configuration parameters for Twitter api
  @@config = YAML::load(File.open("#{::Rails.root.to_s}/config/twitter.yml"))

end
