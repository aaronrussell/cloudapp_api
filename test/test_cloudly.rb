require 'helper'

class TestCloudAppAPI < Test::Unit::TestCase

  should "test retreiving a listing of my uploaded files." do
    flunk "Couldn't create client" if client.nil?
    items = client.items
    unless items.class == ::Array
      flunk "Couldn't retrieve the items"
    end
  end

end
