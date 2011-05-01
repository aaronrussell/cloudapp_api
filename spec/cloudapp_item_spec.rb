require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CloudApp::Item do
  
  before(:each) do
    fake_it_all
    @item = CloudApp::Item.find "2wr4"
  end
  
  it "should be a Item object" do
    @item.should be_a_kind_of CloudApp::Item
  end
  
  it "should return a name" do
    @item.name.should == "CloudApp Logo.png"
  end
  
  it "should return an href" do
    @item.href.should == "http://my.cl.ly/items/1912559"
  end
  
  it "should return a privacy boolean" do
    @item.private.should == false
  end
  
  it "should return a url" do
    @item.url.should == "http://cl.ly/2wr4"
  end
  
  it "should return a content url" do
    @item.content_url.should == "http://cl.ly/2wr4/CloudApp_Logo.png"
  end
  
  it "should return a item type" do
    @item.item_type.should == "image"
  end
  
  it "should return a view counter" do
    @item.view_counter.should == 42
  end
  
  it "should return an icon url" do
    @item.icon.should == "http://my.cl.ly/images/item_types/image.png"
  end
  
  it "should return a remote url" do
    @item.remote_url == "http://f.cl.ly/items/7c7aea1395c3db0aee18/CloudApp%20Logo.png"
  end
  
  it "should not return a redirect url" do
    @item.redirect_url == nil
  end
  
  it "should return timestamps" do
    @item.created_at.should be_a_kind_of Time
    @item.updated_at.should be_a_kind_of Time
    @item.deleted_at.should == nil
  end
  
end


describe "Bookmark link" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @name = "CloudApp"
    @redirect_url = "http://getcloudapp.com"
    @item = CloudApp::Item.create :bookmark, {:name => @name, :redirect_url => @redirect_url}
  end
  
  it "should be a Item object" do
    @item.should be_a_kind_of CloudApp::Item
  end
  
  it "should return the same name" do
    @item.name.should == @name
  end
  
  it "should return the same redirect_url" do
    @item.redirect_url.should == @redirect_url
  end
  
end


describe "Bookmark multiple links" do
  
  before(:each) do
    fake_it_all
    # overwrite the normal fake uri for this spec
    FakeWeb.register_uri :post, 'http://my.cl.ly/items', :response => stub_file(File.join('item', 'index'))
    CloudApp.authenticate "testuser@test.com", "password"
    @bookmarks = [
      { :name         => "Authur Dent",       :redirect_url => "http://en.wikipedia.org/wiki/Arthur_Dent" },
      { :name         => "Ford Prefect",      :redirect_url => "http://en.wikipedia.org/wiki/Ford_Prefect_(character)"},
      { :name         => "Zaphod Beeblebrox", :redirect_url => "http://en.wikipedia.org/wiki/Zaphod_Beeblebrox" }
    ]
    @items = CloudApp::Item.create :bookmarks, @bookmarks
  end
  
  it "should be an Array" do
    @items.should be_a_kind_of Array
  end
  
  it "should contain Item objects" do
    @items.each do |item|
      item.should be_a_kind_of CloudApp::Item
    end
  end
    
end


describe "Change security of an item" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @item = CloudApp::Item.update "http://my.cl.ly/items/1912565", {:private => false}
  end
  
  it "should be an Item object" do
    @item.should be_a_kind_of CloudApp::Item
  end
  
  it "should not be private" do
    @item.private.should == false
  end
  
end



describe "Delete an item" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @item = CloudApp::Item.delete "http://my.cl.ly/items/1912565"
  end
  
  it "should be an Item object" do
    @item.should be_a_kind_of CloudApp::Item
  end
  
  it "should have a deleted_at timestamp" do
    @item.deleted_at.should be_a_kind_of Time
  end
  
end


describe "Empty trash" do
end


describe "List items" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @items = CloudApp::Item.all
  end
  
  it "should be an Array" do
    @items.should be_a_kind_of Array
  end
  
  it "should contain Item objects" do
    @items.each do |item|
      item.should be_a_kind_of CloudApp::Item
    end
  end
  
end


describe "Recover deleted item" do
end


describe "Rename item" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @name = "CloudApp"
    @item = CloudApp::Item.update "http://my.cl.ly/items/1912565", {:name => @name}
  end
  
  it "should be an Item object" do
    @item.should be_a_kind_of CloudApp::Item
  end
  
  it "should be have the same name" do
    @item.name.should == @name
  end
  
end


describe "Upload file" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @item = CloudApp::Item.create :upload, {:file => "README.md"}
  end
  
  it "should be an Item object" do
    @item.should be_a_kind_of CloudApp::Item
  end
  
  it "should return a item type" do
    @item.item_type.should == "image"
  end
  
end



