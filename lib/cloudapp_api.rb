require "httparty"

["base", "item", "client", "multipart", "httparty"].each do |inc|
  require File.join(File.dirname(__FILE__), "cloudapp", inc)
end

module CloudApp
  
  VERSION = "0.1.0"
  
  # Sets the authentication credentials in a class variable
  # @param [String] cl.ly username
  # @param [String] cl.ly password
  # @return [Hash] authentication credentials
  def CloudApp.authenticate(username, password)
    Base.authenticate(username, password)
  end
    
end
