require 'helper'

class TestBase < Test::Unit::TestCase
  def setup
    @auth = CloudApp::Base.authenticate( cloudapp_config[:username], cloudapp_config[:password] )
  end
  
  should "be able to enter authentication info" do
    setup
    assert @auth, "CloudApp::Base.authenticate shouldn't have returned falsey value"
  end
  
  should "be able to find an item by public slug" do
    setup
    item = CloudApp::Base.find random_slug
    assert_instance_of CloudApp::Item, item
  end
  
end
