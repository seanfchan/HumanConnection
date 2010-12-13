# == Schema Information
# Schema version: 20101119035757
#
# Table name: facebook_accounts
#
#  id             :integer         not null, primary key
#  account_type   :string(255)     default("FacebookAccount")
#  person_id      :integer
#  last_sync_time :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  unique_id      :string(255)
#  login          :string(255)
#  oauth_token    :string(255)
#
#

# File:: facebook_account.rb
#
# Author::  Jon Boekenoogen (mailto: jboekeno@gmail.com)
# Commented by::  Madiha Mubin 
# Copyright::  Copyright (c) 2010 <INSERT_COMPANY_NAME>

require 'oauth'
require 'model_mixins/account_properties'
require 'connection'

# This class represents a Facebook Account in the database.
# For reference, go to https://github.com/nsanta/fbgraph
class FacebookAccount < ActiveRecord::Base
  include AccountProperties

  # Accessors
  attr_accessible :unique_id, :login

  # Validation
  validates :unique_id, :presence => true, 
    :uniqueness => true

  # Performs a check to see if this account could be valid. 
  # === Return
  # true if could be valid, false otherwise
  def authorized?
    !oauth_token.blank?
  end

  # Sets the oauth_token for an account.
  # Accomplished by asking Facebook for access token given the following
  # parameters.
  # ==== Parameters
  # * +code+ - Facebook App credentials
  # * +options+ - Html options that are requird by FB api. None for now
  # === Return
  # access token from Facebook
  def authorize(code, options = {})
    access_token = client.authorization.process_callback(code, options)
    self.oauth_token = access_token
    access_token
  end

  # Finds an existing FacebookAccount using unique_id of self
  # === Return 
  # Existing account if found, nil otherwise
  def existing
    return self.class.find_by_unique_id(unique_id)
  end

  # Check whether this account and another can be merged
  # === Parameters
  # * +other+ - other object to be merged with
  # === Return 
  # true if mergeable, false otherwise
  def mergeable(other)
    return unique_id == other.unique_id
  end

  # Accessing Facebook Api to populate contact information into the database.
  # TODO: Removing connections if no longer friends under ANY accounts.
  #
  # === Steps:
  # * Check if account is valid or can be valid
  # * Download account's information and their friends' information
  # * Add friend as Person/FacebookAccount if not in DB
  # * Add friend as a connection if not in DB
  # * Special treatment to Significant others, family relationships
  # === Return
  # None
  def sync_contacts
    # Check against ActiveRecord validators
    return if !(valid? || authorized?)

    me = client.selection.me
    
    # Perform all api requests in one place for easier exception handling
    # Wrap in exception in case access has been revoked
    begin
      my_data = me.info!
      friends = me.friends.info!
    rescue
      # Nothing we can really do here. So just return. 
      # We need to check these on startup and prompt the user to either
      # delete their Facebook account or grant access again.
      logger.debug "Facebook access for person #{person.id if person} has been revoked"
      return
    end

    old_connection_count = person.connections.length

    # Family/Significant other relationships go first as they are included in friends

    # Significant other relationship
    sig_other = my_data.significant_other
    if sig_other
      # Check if in DB or create
      sig_other_account = find_or_create(:unique_id, {:unique_id => sig_other.id})
      
      # Check if they are connected already or create the connection
      connection = SignificantOtherConnection.find_or_create(person.id, sig_other_account.person.id)
    end

    # Family relationships
    # NEED TO IMPLEMENT - can't find it in the api yet

    # Friend relationships
    data = friends.data

    logger.debug "Facebook Sync: Start #{data.length} Facebook accounts for Person #{person.id}"
    
    # Add each friend to the database
    data.each do |friend| 
      # Check if in DB or create
      friend_account = find_or_create(:unique_id, {:unique_id => friend.id})

      # Check if they are connected already or create the connection
      connection = FriendConnection.find_or_create(person.id, friend_account.person.id)
    end

    # NOTE: Need to remove connections that are no longer relevant

    # Force a query to the DB again
    # Probably want to remove this in the future for performance
    new_connection_count = person.connections(true).length
    connection_delta = new_connection_count - old_connection_count

    logger.debug "Facebook Sync: Complete #{connection_delta} new connections, before #{old_connection_count} after #{new_connection_count}"
  end

  # Main access point for the FB api. Use this object for all api 
  # interactions. Client is cached until forced to reload
  # === Parameters
  # * +force+ - Force a reload on the client.
  # === Return 
  # Facebook Client to use for api access, else nil
  def client(force = false)
    if force || !@client
      @client = FBGraph::Client.new(:client_id => @@config["app_id"],
                                    :secret_id => @@config["app_secret"],
                                    :token => oauth_token)
    end
    @client
  end

  # Convenience metho for accessing configuration parameters.
  # === Return
  # Facebook configuration as a YAML hash
  def self.config
    @@config
  end

  # Configuration parameters for Facebook API
  @@config = YAML::load(File.open("#{::Rails.root.to_s}/config/facebook.yml"))

end
