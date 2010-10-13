require 'helper'

class TestCloudAppAPI < Test::Unit::TestCase
  
  should "Test for username and password for CloudApp." do
    email = cloudapp_config['email']
    password = cloudapp_config['password']
    flunk "The test will need your email" if email.blank?
    flunk "The test will need your password" if password.blank?
  end
  
  should "Test retreiving a listing of my uploaded files." do
    client = CloudApp::Client.new :username => cloudapp_config['email'],
                                  :password => cloudapp_config['password']
    flunk "Couldn't create client" if client.nil?
    items = client.items
    unless items.code == 200  # something is wrong with HTTParty::Response#ok?
      flunk "Couldn't login to CloudApp.  Check your email and password in test_config.yml"
    end
  end
  
end
