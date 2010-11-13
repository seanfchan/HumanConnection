# == Schema Information
# Schema version: 20101103135942
#
# Table name: accounts
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  login          :string(255)
#  password       :string(255)
#  oauth_token    :string(255)
#  oauth_secret   :string(255)
#  phone_number   :string(255)
#  last_sync_time :datetime
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Account < ActiveRecord::Base

  protected

  # Accessors
  attr_accessible :type, :last_sync_time, :user_id

  # Relationships
  belongs_to :user

  # Validation
  # Don't allow duplicate logins for same account type
  validates :user_id, :presence => true,
    :uniqueness => {:scope => [:type, :login]}
  validates :type, :presence => true

end

# Email Accounts
class EmailAccount < Account

  protected

  attr_accessible :login, :password
  validates :login,    :presence => true
  validates :password, :presence => true
end
class GmailAccount < Account; end
class HotmailAccount < Account; end
class YahooAccount < Account; end

# Phone Accounts
class PhoneAccount < Account

  protected

  attr_accessible :phone_number
  validates :phone_number, :presence => true
end
class IPhoneAccount < PhoneAccount; end
class AndroidAccount < PhoneAccount; end
class WinMobAccount < PhoneAccount; end
class BlackBerryAccount < PhoneAccount; end

# Social Networking Accounts
class SocialNetworkAccount < Account
  attr_accessible :login, :oauth_token
end
class FacebookAccount < SocialNetworkAccount

  def authorized?
    !oauth_token.blank?
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

class TwitterAccount < SocialNetworkAccount
  attr_accessible :oauth_secret

  def authorized?
    oauth_token.blank? && oauth_secret.blank?
  end

  def authorize(rtoken, rsecret, options = {})
    request_token = OAuth::RequestToken.new(
      consumer, rtoken, rsecret
    )
    access_token = request_token.get_access_token(options)
    oauth_token = access_token.token
    oauth_secret = access_token.secret
    access_token
  end

  def request_token(options = {})
    options[:oauth_callback] = callback_twitter_account_path
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

  def client
    @client ||= begin
                  consumer.authorize_from_access(oauth_token, oauth_secret)
                  Twitter::Base.new(oauth)
                end
  end

  def self.config
    @@config 
  end

  @@config = YAML::load(File.open("#{::Rails.root.to_s}/config/twitter.yml"))

end

class MyspaceAccount < SocialNetworkAccount; end
