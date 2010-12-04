# == Schema Information
# Schema version: 20101119035757
#
# Table name: twitter_accounts
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

require 'oauth'
require 'model_mixins/account_properties'

class TwitterAccount < ActiveRecord::Base
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
