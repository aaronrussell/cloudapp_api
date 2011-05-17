require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CloudApp::ResponseError, "when not logged in" do
  
  before(:each) do
    fake_it_all_with_errors
    @error = lambda { CloudApp::Drop.all }
  end
  
  it "should raise a 401" do
    @error.should raise_error(CloudApp::ResponseError, "401 Unauthorized")
  end
  
  it "should return a code and error messages" do
    @error.should raise_error{|e|
      e.code.should == 401
      e.errors[0].should == "HTTP Digest: Access denied."
    }
  end
  
end


describe CloudApp::ResponseError, "when item doesn't exist" do
  
  before(:each) do
    fake_it_all_with_errors
    @error = lambda { CloudApp::Drop.find "12345" }
  end
  
  it "should raise a 404" do
    @error.should raise_error(CloudApp::ResponseError, "404 Not Found")
  end
  
  it "should return a code and error messages" do
    @error.should raise_error{|e|
      e.code.should == 404
      e.errors[0].should == "<h1>Not Found</h1>"
    }
  end
  
end


describe CloudApp::ResponseError, "when updating someone elses item" do
  
  before(:each) do
    fake_it_all_with_errors
    @error = lambda { CloudApp::Drop.update "http://my.cl.ly/items/12345" }
  end
  
  it "should raise a 404" do
    pending "CloudApp shouldn't return a HTML response (or a 404 for that matter)" do
      @error.should raise_error(CloudApp::ResponseError, "404 Not Found")
    end
  end
  
  it "should return a code and error messages" do
    pending "CloudApp shouldn't return a HTML response (or a 404 for that matter)" do
      @error.should raise_error{|e|
        e.code.should == 404
      }
    end
  end
  
end


describe "when recovering an unrecoverable item" do
  
  before(:each) do
    fake_it_all_with_errors
    @error = lambda { CloudApp::Drop.recover "http://my.cl.ly/items/12345" }
  end
  
  it "should raise a 404" do
    pending "CloudApp shouldn't return a HTML response" do
      @error.should raise_error(CloudApp::ResponseError, "404 Not Found")
    end
  end
  
  it "should return a code and error messages" do
    pending "CloudApp shouldn't return a HTML response" do
      @error.should raise_error{|e|
        e.code.should == 404
      }
    end
  end
  
end


describe CloudApp::ResponseError, "badly formatted bookmark" do
  
  before(:each) do
    fake_it_all_with_errors
    FakeWeb.register_uri :post, 'http://my.cl.ly/items', :response => stub_file(File.join('error', '422-bookmark'))
    CloudApp.authenticate "testuser@test.com", "password"
    @error = lambda { CloudApp::Drop.create :bookmark }
  end
  
  it "should raise a 422" do
    @error.should raise_error(CloudApp::ResponseError, "422")
  end
  
  it "should return an array of error messages" do
    @error.should raise_error{|e|
      e.errors.should be_a_kind_of(Array)
      e.errors[0].should == "URL can't be blank"
    }
  end
  
end


describe CloudApp::ResponseError, "badly formatted bookmarks" do
  
  before(:each) do
    fake_it_all_with_errors
    FakeWeb.register_uri :post, 'http://my.cl.ly/items', :response => stub_file(File.join('error', '422-bookmarks'))
    CloudApp.authenticate "testuser@test.com", "password"
    @error = lambda { CloudApp::Drop.create :bookmarks, [{}] }
  end
  
  it "should raise a 422" do
    @error.should raise_error(CloudApp::ResponseError, "422")
  end
  
  it "should return a nested array of error messages" do
    @error.should raise_error{|e|
      e.errors.should be_a_kind_of(Array)
      e.errors[0].should be_a_kind_of(Array)
      e.errors[0][0].should == "URL can't be blank"
    }
  end
  
end

