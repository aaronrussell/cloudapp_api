require "httparty"

["base", "client", "httparty"].each do |inc|
  require File.join(File.dirname(__FILE__), "cloudly", inc)
end

module Cloudly
  
  VERSION = "0.0.1"
  
  def Cloudly.authenticate(username, password)
    Base.authenticate(username, password)
  end
    
end
