require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CloudApp::Account do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @account = CloudApp::Account.find
  end
  
  it "should be a User object" do
    @account.should be_a_kind_of CloudApp::Account
  end
  
  it "should return an id" do
    @account.id.should == 1
  end
  
  it "should return an email" do
    @account.email.should == "arthur@dent.com"
  end
  
  it "should return a blank domain" do
    @account.domain.should == nil
  end
  
  it "should return a blank domain home page" do
    @account.domain_home_page.should == nil
  end
  
  it "should return a private items booleans" do
    @account.private_items.should == true
  end
  
  it "should return a subscribed boolean" do
    @account.subscribed.should == false
  end
  
  it "should return a alpha boolean" do
    @account.alpha.should == false
  end
  
  it "should return timestamps" do
    @account.created_at.should be_a_kind_of Time
    @account.updated_at.should be_a_kind_of Time
    @account.activated_at.should be_a_kind_of Time
  end
  
end


describe "Change default security" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @account = CloudApp::Account.update :private_items => false
  end
  
  it "should be a User object" do
    @account.should be_a_kind_of CloudApp::Account
  end
  
  it "should have private items set to false" do
    @account.private_items.should == false
  end
  
end


describe "Change email" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @email = "ford@prefect.com"
    @account = CloudApp::Account.update :email => @email, :current_password => "towel"
  end
  
  it "should be a User object" do
    @account.should be_a_kind_of CloudApp::Account
  end
  
  it "should have the new email address" do
    @account.email.should == @email
  end
  
end


describe "Change password" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @account = CloudApp::Account.update :password => "hoopy frood", :current_password => "towel"
  end
  
  it "should be a User object" do
    @account.should be_a_kind_of CloudApp::Account
  end
  
end


describe "Reset password" do
  
  before(:each) do
    fake_it_all
    @response = CloudApp::Account.reset :email => "arthur@dent.com"
  end
  
  it "should return true" do
    @response.should == true
  end
  
end


describe "Register user" do
  
  before(:each) do
    fake_it_all
    @email = "arthur@dent.com"
    @account = CloudApp::Account.create :email => @email, :current_password => "towel"
  end
  
  it "should be a User object" do
    @account.should be_a_kind_of CloudApp::Account
  end
  
  it "should do something" do
    @account.email.should == @email
  end
  
end


describe "Set custom domain" do
  
  before(:each) do
    fake_it_all
    CloudApp.authenticate "testuser@test.com", "password"
    @domain = "dent.com"
    @dhp = "http://hhgproject.org"
    @account = CloudApp::Account.update :domain => @domain, :domain_home_page => @dhp
  end
  
  it "should be a User object" do
    @account.should be_a_kind_of CloudApp::Account
  end
  
  it "should have the same domain" do
    @account.domain.should == @domain
  end
  
  it "should have the same domain home page" do
    @account.domain_home_page.should == @dhp
  end
  
end

