require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'treetop'
require 'yaml'

TEST_DIR = File.join(File.dirname(__FILE__))

$LOAD_PATH.unshift(File.join(TEST_DIR, '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'setup_faking'
require 'cloudapp_api'

class Test::Unit::TestCase
  
  def cloudapp_config
    @@cloudapp_config ||= {:username=> 'fake@example.com', :password=>'foobar'}
  end
  
  def client
    @@client ||= CloudApp::Client.new cloudapp_config
  end
  
end
