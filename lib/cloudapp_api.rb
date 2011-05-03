require "httparty"

["base", "drop", "account", "gift_card", "client", "multipart", "httparty", "core_ext"].each do |inc|
  require File.join(File.dirname(__FILE__), "cloudapp", inc)
end

# A simple Ruby wrapper for the CloudApp API. Uses HTTParty and provides
# two alternative interfaces for interracting with the API.
# An ActiveResource-like interface is provided alongside a simple client interface.
module CloudApp
  
  # Version number
  VERSION = "0.2.1"
  
  # Sets the authentication credentials in a class variable
  #
  # @param [String] email cl.ly username
  # @param [String] password cl.ly password
  # @return [Hash] authentication credentials
  def CloudApp.authenticate(email, password)
    Base.authenticate(email, password)
  end
  
  # Temporary generic error raised on all bad requests
  #
  # #TODO - implement MUCH better error handling
  class GenericError < StandardError; end
    
end
