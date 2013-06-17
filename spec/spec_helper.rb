$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fakeweb_helper.rb'
require 'cloudapp_api'
require 'coveralls'
Coveralls.wear!

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.color_enabled = true

  config.before :suite do
    FakeWeb.allow_net_connect = false
  end

  config.after :suite do
    FakeWeb.allow_net_connect = true
  end
end
