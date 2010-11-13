require 'helper'

class TestCloudAppAPI < Test::Unit::TestCase

  should "be able to create a client" do
    assert_instance_of CloudApp::Client, client, "Couldn't create client."
  end

  should "test retreiving a listing of my uploaded files." do
    items = client.items
    assert_instance_of Array, items, "Couldn't retrieve the items."
  end
  
  should "test creating a bookmark" do
    b = client.bookmark("CloudApp","http://cloudapp.com")
    assert_instance_of CloudApp::Item, b, "Failed to create a bookmark."
  end
  
  should "be able to delete an item" do
    res = client.delete "rAnD"
    assert_same true, res, "Couldn't delete an item"
    
    bad_res = client.delete "rAnD"
    message = "Shouldn't be able to delete the same item"
    assert_not_same true, bad_res, message
    # HTTParty::Response has no instance_of? method so
    # we can't use assert_instance_of
    assert bad_res.class == HTTParty::Response, message
  end
  
  should "be able to upload a file" do
    res = client.upload "README.md"
    assert_instance_of CloudApp::Item, res, "Couldn't upload the file"
  end

  ### Can't think of any other test to add at the moment

end
