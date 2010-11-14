require 'account'

class LinkedInAccount < Account
  attr_accessible :oauth_secret

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

  validates :oauth_token, :presence => true
  validates :oauth_secret, :presence => true

end
