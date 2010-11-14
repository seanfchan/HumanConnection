require 'account'

class FacebookAccount < Account

  def authorized?
    !@oauth_token.blank?
  end
  
  def authorize(code, options = {})
    access_token = client.authorization.process_callback(code, options)
    self.oauth_token = access_token
    access_token
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

  validates :oauth_token, :presence => true

end
