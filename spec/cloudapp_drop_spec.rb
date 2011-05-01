require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CloudApp::Drop do
  
  before(:each) do
    fake_it_all
    @drop = CloudApp::Drop.find "2wr4"
  end
  
  it "should be a Drop object" do
    @drop.should be_a_kind_of CloudApp::Drop
  end
  
  it "should return a name" do
    @drop.name.should == "CloudApp Logo.png"
  end
  
  it "should return an href" do
    @drop.href.should == "http://my.cl.ly/items/1912559"
  end
  
  it "should return a privacy boolean" do
    @drop.private.should == false
  end
  
  it "should return a url" do
    @drop.url.should == "http://cl.ly/2wr4"
  end
  
  it "should return a content url" do
    @drop.content_url.should == "http://cl.ly/2wr4/CloudApp_Logo.png"
  end
  
  it "should return a drop type" do
    @drop.item_type.should == "image"
  end
  
  it "should return a view counter" do
    @drop.view_counter.should == 42
  end
  
  it "should return an icon url" do
    @drop.icon.should == "http://my.cl.ly/images/item_types/image.png"
  end
  
  it "should return a remote url" do
    @drop.remote_url == "http://f.cl.ly/items/7c7aea1395c3db0aee18/CloudApp%20Logo.png"
  end
  
  it "should not return a redirect url" do
    @drop.redirect_url == nil
  end
  
  it "should return timestamps" do
    @drop.created_at.should be_a_kind_of Time
    @drop.updated_at.should be_a_kind_of Time
    @drop.deleted_at.should == nil
  end
  
end


describe "Bookmark link" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @name = "CloudApp"
    @redirect_url = "http://getcloudapp.com"
    @drop = CloudApp::Drop.create :bookmark, {:name => @name, :redirect_url => @redirect_url}
  end
  
  it "should be a Drop object" do
    @drop.should be_a_kind_of CloudApp::Drop
  end
  
  it "should return the same name" do
    @drop.name.should == @name
  end
  
  it "should return the same redirect_url" do
    @drop.redirect_url.should == @redirect_url
  end
  
end


describe "Bookmark multiple links" do
  
  before(:each) do
    fake_it_all
    # overwrite the normal fake uri for this spec
    FakeWeb.register_uri :post, 'http://my.cl.ly/items', :response => stub_file(File.join('drop', 'index'))
    CloudApp.authenticate "testuser@test.com", "password"
    @bookmarks = [
      { :name         => "Authur Dent",       :redirect_url => "http://en.wikipedia.org/wiki/Arthur_Dent" },
      { :name         => "Ford Prefect",      :redirect_url => "http://en.wikipedia.org/wiki/Ford_Prefect_(character)"},
      { :name         => "Zaphod Beeblebrox", :redirect_url => "http://en.wikipedia.org/wiki/Zaphod_Beeblebrox" }
    ]
    @drops = CloudApp::Drop.create :bookmarks, @bookmarks
  end
  
  it "should be an Array" do
    @drops.should be_a_kind_of Array
  end
  
  it "should contain Drop objects" do
    @drops.each do |drop|
      drop.should be_a_kind_of CloudApp::Drop
    end
  end
    
end


describe "Change security of an drop" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @drop = CloudApp::Drop.update "http://my.cl.ly/items/1912565", {:private => false}
  end
  
  it "should be an Drop object" do
    @drop.should be_a_kind_of CloudApp::Drop
  end
  
  it "should not be private" do
    @drop.private.should == false
  end
  
end



describe "Delete a drop" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @drop = CloudApp::Drop.delete "http://my.cl.ly/items/1912565"
  end
  
  it "should be an Drop object" do
    @drop.should be_a_kind_of CloudApp::Drop
  end
  
  it "should have a deleted_at timestamp" do
    @drop.deleted_at.should be_a_kind_of Time
  end
  
end


describe "Empty trash" do
end


describe "List drops" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @drops = CloudApp::Drop.all
  end
  
  it "should be an Array" do
    @drops.should be_a_kind_of Array
  end
  
  it "should contain Drop objects" do
    @drops.each do |drop|
      drop.should be_a_kind_of CloudApp::Drop
    end
  end
  
end


describe "Recover deleted drop" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @drop = CloudApp::Drop.recover "http://my.cl.ly/items/1912565"
  end
  
  it "should be an Drop object" do
    @drop.should be_a_kind_of CloudApp::Drop
  end
  
  it "should not have a deleted_at timestamp" do
    @drop.deleted_at.should == nil
  end
  
end


describe "Rename drop" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @name = "CloudApp"
    @drop = CloudApp::Drop.update "http://my.cl.ly/items/1912565", {:name => @name}
  end
  
  it "should be an Drop object" do
    @drop.should be_a_kind_of CloudApp::Drop
  end
  
  it "should be have the same name" do
    @drop.name.should == @name
  end
  
end


describe "Upload file" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @drop = CloudApp::Drop.create :upload, {:file => "README.md"}
  end
  
  it "should be an Drop object" do
    @drop.should be_a_kind_of CloudApp::Drop
  end
  
  it "should return a drop type" do
    @drop.item_type.should == "image"
  end
  
end


describe "Upload file with specific privacy" do
  
  before(:each) do
    fake_it_all
    # override the upload fakeweb uri
    FakeWeb.register_uri :post, 'http://f.cl.ly', :status => ["303"], :location => "http://my.cl.ly/items/s3?item[private]=true"
    CloudApp.authenticate "testuser@test.com", "password"
    @drop = CloudApp::Drop.create :upload, {:file => "README.md", :private => true}
  end
  
  it "should be an Drop object" do
    @drop.should be_a_kind_of CloudApp::Drop
  end
  
  it "should return as private" do
    @drop.private.should == true
  end
  
end


