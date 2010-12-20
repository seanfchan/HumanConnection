# Load the rails application
require File.expand_path('../application', __FILE__)

# Files to be loaded for entire app.
# NOTE: Need to do after app initialization for testing
require 'ruby_ext/string_ext'

# Initialize the rails application
HumanConnections::Application.initialize!

