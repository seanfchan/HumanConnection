# Load the rails application
require File.expand_path('../application', __FILE__)

# Files to be loaded for entire app.
# NOTE: Need to do after app initialization for testing
require 'ruby_ext/string_ext'

# Initialize the rails application
HumanConnections::Application.initialize!

# Set up ActionMailer
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default :charset => "utf-8"
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => 'gmail.com',
  :user_name => "humanconnections11@gmail.com",
  :password => "HuM41nC0nn3ct1ons",
  :authentication => :plain
}

