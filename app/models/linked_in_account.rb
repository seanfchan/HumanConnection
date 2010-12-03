# == Schema Information
# Schema version: 20101119035757
#
# Table name: linked_in_accounts
#
#  id             :integer         not null, primary key
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
  validates :oauth_token, :presence => true
  validates :oauth_secret, :presence => true

  def authorized?
    !oauth_token.blank? && !oauth_secret.blank?
  end

  def authorize(rtoken, rsecret, oauth_verifier)
    access_token = client.authorize_from_request(rtoken, rsecret, oauth_verifier)
    self.oauth_token = access_token[0]
    self.oauth_secret = access_token[1]
    access_token
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
