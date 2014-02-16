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
    
    # Define empty auth hash
    @@auth = {}
    
    # Sets the authentication credentials in a class variable.
    #
    # @param [String] email cl.ly email
    # @param [String] password cl.ly password
    # @return [Hash] authentication credentials
    def self.authenticate(email, password)
      @@auth = {:username => email, :password => password}
    end
    
    # Examines a bad response and raises an approriate exception
    #
    # @param [HTTParty::Response] response
    def self.bad_response(response)
      if response.class == HTTParty::Response
        raise ResponseError, response
      end
      raise StandardError, "Unknown error"
    end

    attr_reader :data

    # Create a new CloudApp::Base object.
    #
    # Only used internally
    #
    # @param [Hash] attributes
    # @return [CloudApp::Base]
    def initialize(attributes = {})
      @data = attributes
      load(@data)
    end
    
    private
    
    # Sets the attributes for object.
    #
    # @param [Hash] attributes
    def load(attributes = {})
      attributes.each do |key, val|
        if key =~ /^.*_at$/ and val
          # if this is a date/time key and it's not nil, try to parse it first
          # as DateTime, then as Date only
          begin
            dt = DateTime.strptime(val, "%Y-%m-%dT%H:%M:%SZ")
            newval = Time.utc(dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec)
          rescue ArgumentError => ex
            newval = DateTime.strptime(val, "%Y-%m-%d")
          end
          self.instance_variable_set("@#{key}", newval)
        else
          self.instance_variable_set("@#{key}", val)
        end
      end
    end
    
  end  
  
end
