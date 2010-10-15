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
    @cloudapp_config ||= YAML.load_file('test/test_config.yml')['cloudapp']
  rescue Errno::ENOENT
    flunk "No test_config.yml file was found."
  end
  
  def client
    @client ||= CloudApp::Client.new :username => cloudapp_config['email'],
                                     :password => cloudapp_config['password']
  end
  
end
