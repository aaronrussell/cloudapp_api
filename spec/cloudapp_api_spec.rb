require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CloudApp do
  
  it "should set correct headers" do
    CloudApp::HEADERS['User-Agent'].should    == "Ruby.CloudApp.API"
    CloudApp::HEADERS['Accept'].should        == "application/json"
    CloudApp::HEADERS['Content-Type'].should  == "application/json"
  end
  
  it "should be authenticatable" do
    auth = {
      :username => "test@test.com",
      :password => "password"
    }
    CloudApp.authenticate(auth[:username], auth[:password]).should == auth
  end
  
end

