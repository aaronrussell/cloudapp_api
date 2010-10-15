require 'helper'

class TestCloudAppAPI < Test::Unit::TestCase

  should "be able to create a client" do    
    flunk "Couldn't create client." if client.nil?
  end

  should "test retreiving a listing of my uploaded files." do
    items = client.items
    unless items.class == ::Array
      flunk "Couldn't retrieve the items."
    end
  end
  
  should "test creating a bookmark" do
    unless client.bookmark("CloudApp","http://cloudapp.com").class == ::CloudApp::Item
      flunk "Failed to create a bookmark."
    end
  end
  
  should "be able to delete an item" do
    res = client.delete "rAnD"
    flunk "Couldn't delete an item" unless res === true
    
    res = client.delete "rAnD"
    flunk "Shouldn't be able to delete the same item" if !res.respond_to?(:code) && res.code != 404
  end

end
