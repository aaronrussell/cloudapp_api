require "httparty"

["base", "item", "account", "client", "multipart", "httparty"].each do |inc|
  require File.join(File.dirname(__FILE__), "cloudapp", inc)
end

# A simple Ruby wrapper for the CloudApp API. Uses HTTParty and provides
# two alternative interfaces for interracting with the API.
# An ActiveResource-like interface is provided alongside a simple client interface.
module CloudApp
  
  # Version number
  VERSION = "0.1.0"
  
  # Sets the authentication credentials in a class variable
  #
  # @param [String] username cl.ly username
  # @param [String] password cl.ly password
  # @return [Hash] authentication credentials
  def CloudApp.authenticate(username, password)
    Base.authenticate(username, password)
  end
    
end
