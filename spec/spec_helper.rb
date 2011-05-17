$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'family-reunion'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

@ants_primary_node = JSON.load(open(File.join(File.dirname(__FILE__), 'fixtures', 'ants_primary.json')).read)
@ants_secondary_node = JSON.load(open(File.join(File.dirname(__FILE__), 'fixtures', 'ants_secondary.json')).read)
