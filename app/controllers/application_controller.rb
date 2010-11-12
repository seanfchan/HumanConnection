class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  protect_from_forgery

  protected

  def fb_client(access_token = nil)
    # Load up the fbgraph client if it is not defined yet
    @@fb_client ||= FBGraph::Client.new(:client_id => @@fb_config["app_id"],
                                        :secret_id => @@fb_config["app_secret"], 
                                        :token => access_token)
  end

  def twitter_client(access_token)

  end

  def linked_in_client(access_token)

  end

  # Class variables for configuration
  @@fb_config = YAML::load(File.open("#{RAILS_ROOT}/config/facebook.yml"))
  @@twiiter_config = YAML::load(File.open("#{RAILS_ROOT}/config/twitter.yml"))
  @@linked_in_config = YAML::load(File.open("#{RAILS_ROOT}/config/linked_in.yml"))

end
