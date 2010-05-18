require "httparty"

["base", "client", "multipart", "httparty"].each do |inc|
  require File.join(File.dirname(__FILE__), "cloudapp", inc)
end

module CloudApp
  
  VERSION = "0.0.2"
  
  def CloudApp.authenticate(username, password)
    Base.authenticate(username, password)
  end
    
end
