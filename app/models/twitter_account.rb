require 'account'
require 'oauth'

class TwitterAccount < Account
  attr_accessible :oauth_secret

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

  validates :oauth_token, :presence => true
  validates :oauth_secret, :presence => true

end
