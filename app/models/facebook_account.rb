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

class FacebookAccount < ActiveRecord::Base
  include AccountProperties
  
  # Accessors
  attr_accessible :unique_id

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

  def client
    @client ||= FBGraph::Client.new(:client_id => @@config["app_id"],
                                    :secret_id => @@config["app_secret"],
                                    :token => oauth_token)
  end

  def self.config
    @@config
  end

  @@config = YAML::load(File.open("#{::Rails.root.to_s}/config/facebook.yml"))

  # Validation
  validates :oauth_token, :presence => true
  validates :unique_id, :presence => true, 
                    :uniqueness => true

end
