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
    #
    # @param [String] username cl.ly username
    # @param [String] password cl.ly password
    # @return [Hash] authentication credentials
    def self.authenticate(username, password)
      @@auth = {:username => username, :password => password}
    end
    
    private
    
    # Sets the attributes for object.
    #
    # @param [Hash] attributes
    def load(attributes = {})
      attributes.each do |key, val|
        self.instance_variable_set("@#{key}", val)
      end
    end
    
  end  
  
end