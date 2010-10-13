require 'helper'

class TestCloudAppAPI < Test::Unit::TestCase
  should "Test for username and password for CloudApp" do
    email = cloudapp_config['email']
    password = cloudapp_config['password']
    flunk "The test will need your email" if email.blank?
    flunk "The test will need your password" if password.blank?
  end
end
