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
    unless client.bookmark("CloudApp","http://cloudapp.com").class == Item
      flunk "Failed to create a bookmark."
    end
  end

end
