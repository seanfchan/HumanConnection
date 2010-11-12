require 'fb_graph'

debugger
config = YAML::load(File.open("#{RAILS_ROOT}/config/facebook.yml"));

print config

#Instantiate a new application with our app_id so we can get an access token
my_app = FbGraph::Application.new(config['production']['app_id']);

print my_app.to_s + "\n"

acc_tok = my_app.get_access_token(config['production']['client_secret']);
print acc_tok.to_s + "\n" 
 
