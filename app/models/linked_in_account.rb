require 'account'

class LinkedInAccount < Account
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
                    options = {:site => @@config["site"], 
                      :request_endpoint => @@config["site"],
                      :request_token_path => "/oauth/requestToken",
                      :access_token_path => "/oauth/accessToken"}
                    OAuth::Consumer.new(@@config["consumer_token"],
                                        @@config["consumer_secret"],
                                        options)
                  end
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

  validates :oauth_token, :presence => true
  validates :oauth_secret, :presence => true

end
