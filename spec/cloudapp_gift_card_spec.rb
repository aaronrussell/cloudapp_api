require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CloudApp::GiftCard do
  
  before(:each) do
    fake_it_all
    @gift = CloudApp::GiftCard.find "ABC123"
  end
  
  it "should be a GiftCard object" do
    @gift.should be_a_kind_of CloudApp::GiftCard
  end
  
  it "should return an id" do
    @gift.id.should == 1
  end
  
  it "should return a code" do
    @gift.code.should == "ABC123"
  end
  
  it "should return a plan" do
    @gift.plan.should == "pro"
  end
  
  it "should return a months attribute" do
    @gift.months.should == 12
  end
  
  it "should return the gift card url" do
    @gift.href.should == "https://my.cl.ly/gift_cards/ABC123"
  end
  
  it "should return timestamps" do
    @gift.created_at.should be_a_kind_of Time
    @gift.updated_at.should be_a_kind_of Time
    @gift.redeemed_at.should == nil
    @gift.effective_at.should == nil
    @gift.expires_at.should == nil
  end
  
end

describe "Redeem gift card" do
  
  before(:each) do
    fake_it_all
    @gift = CloudApp::GiftCard.redeem "ABC123"
  end
  
  it "should be a GiftCard object" do
    @gift.should be_a_kind_of CloudApp::GiftCard
  end
  
  it "should have a redeemed at time" do
    @gift.redeemed_at.should be_a_kind_of Time
  end
  
  it "should have an effective at date" do
    @gift.effective_at.should be_a_kind_of Date
  end
  
  it "should have an expires at date" do
    @gift.expires_at.should be_a_kind_of Date
  end
  
end
