require 'shoulda/version'

if defined?(RSpec)
  require 'shoulda/integrations/rspec2'
end
if defined?(Spec)
  require 'shoulda/integrations/rspec'
end
require 'shoulda/integrations/test_unit'
