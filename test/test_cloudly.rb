require 'helper'

class TestCloudAppAPI < Test::Unit::TestCase
  
  should "test for username and password for CloudApp." do
    email = cloudapp_config['email']
    password = cloudapp_config['password']
    flunk "The test will need your email" if email.blank?
    flunk "The test will need your password" if password.blank?
  end
  
  should "test retreiving a listing of my uploaded files." do
    flunk "Couldn't create client" if client.nil?
    items = client.items
    unless items.class == ::Array
      flunk "Couldn't login to CloudApp.  Check your email and password in test_config.yml"
    end
  end
  
  context "To create a bookmark" do
    
    should "be able to add a bookmark to my CloudApp account" do
      flunk "Failed to add a bookmark to Google" if theBookmark.class != ::CloudApp::Item
    end
  
    context "and with that bookmark" do
      should "be able to delete it" do
        unless theBookmark.delete == true
          flunk "Failed to delete the bookmark"
        end
      end
    end
      
  end
  
  private
  def theBookmark
    @@bookmark ||= client.bookmark 'http://www.google.com',
                    "Test Bookmark from cloudapp_api rubygem"
  end
  
end
