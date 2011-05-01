require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CloudApp::Client do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @client = CloudApp::Client.new
  end
  
  it "should be reautheticatable" do
    username = "joe.bloggs@testing.com"
    password = "password"
    auth = @client.authenticate username, password
    auth[:username].should == username
  end
  
  it "should find an drop" do
    drop = @client.drop "2wr4"
    drop.should be_a_kind_of CloudApp::Drop
  end
  
  it "should list all drops" do
    drops = @client.drops
    drops.should be_a_kind_of Array
    drops.each do |drop|
      drop.should be_a_kind_of CloudApp::Drop
    end
  end
  
  it "should bookmark an drop" do
    name = "CloudApp"
    drop = @client.bookmark "http://getcloudapp.com", name
    drop.should be_a_kind_of CloudApp::Drop
    drop.name.should == name
  end
  
  it "should bookmark multiple drops" do
    # overwrite the normal fake uri for this spec
    FakeWeb.register_uri :post, 'http://my.cl.ly/items', :response => stub_file(File.join('drop', 'index'))
    bookmarks = [
      { :name         => "Authur Dent",       :redirect_url => "http://en.wikipedia.org/wiki/Arthur_Dent" },
      { :name         => "Ford Prefect",      :redirect_url => "http://en.wikipedia.org/wiki/Ford_Prefect_(character)"},
      { :name         => "Zaphod Beeblebrox", :redirect_url => "http://en.wikipedia.org/wiki/Zaphod_Beeblebrox" }
    ]
    drops = @client.bookmark bookmarks
    drops.should be_a_kind_of Array
    drops.each do |drop|
      drop.should be_a_kind_of CloudApp::Drop
    end
  end
  
  it "should upload a file" do
    drop = @client.upload "README.md"
    drop.should be_a_kind_of CloudApp::Drop
    drop.item_type.should == "image"
  end
  
  it "should upload a file with specific privacy" do
    # override the upload fakeweb uri
    FakeWeb.register_uri :post, 'http://f.cl.ly', :status => ["303"], :location => "http://my.cl.ly/items/s3?item[private]=true"
    drop = @client.upload "README.md", :private => true
    drop.should be_a_kind_of CloudApp::Drop
    drop.private.should == true
  end
  
  it "should rename an drop" do
    name = "CloudApp"
    drop = @client.rename "2wr4", name
    drop.should be_a_kind_of CloudApp::Drop
    drop.name.should == name
  end
  
  it "should set an drops privacy" do
    drop = @client.privacy "2wr4", false
    drop.should be_a_kind_of CloudApp::Drop
    drop.private.should == false
  end
  
  it "should delete an drop" do
    drop = @client.delete "2wr4"
    drop.should be_a_kind_of CloudApp::Drop
    drop.deleted_at.should be_a_kind_of Time
  end
  
  it "should recover an drop" do
    drop = @client.recover "2wr4"
    drop.should be_a_kind_of CloudApp::Drop
    drop.deleted_at.should == nil
  end
  
end
