require "httparty"

module CloudApp
  
  # Globally set request headers
  HEADERS = {
    "User-Agent"    => "Ruby.CloudApp.API",
    "Accept"        => "application/json",
    "Content-Type"  => "application/json"
  }
  
  # Base class for setting HTTParty configurations globally
  class Base
    
    include HTTParty
    base_uri "my.cl.ly"
    headers HEADERS
    format :json
    
    # Sets the authentication credentials in a class variable.
    # @param [String] cl.ly username
    # @param [String] cl.ly password
    # @return [Hash] authentication credentials
    def self.authenticate(username, password)
      @@auth = {:username => username, :password => password}
    end
    
  end  
  
end