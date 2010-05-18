require "httparty"

module CloudApp
  
  HEADERS = {
    "User-Agent" => "Ruby.CloudApp.API",
    "Accept" => "application/json",
    "Content-Type" => "application/json"
  }
      
  class Base
    
    include HTTParty
    base_uri "my.cl.ly"
    headers HEADERS
    format :json
    
    def self.authenticate(username, password)
      @@auth = {:username => username, :password => password}
    end
    
    def self.find(id)
      res = get "http://cl.ly/#{id}"
      res.ok? ? Item.new(res) : res
    end
    
    def self.all(opts = {})
      res = get "/items", opts.merge!(:digest_auth => @@auth)
      res.ok? ? res.collect{|i| Item.new(i)} : res
    end
    
    def self.create(kind, opts = {})
      case kind
      when :bookmark
        res = post "/items", {:query => {:item => opts}, :digest_auth => @@auth}
      when :upload
        res = get "/items/new", :digest_auth => @@auth
        return res unless res.ok?
        res = post res['url'], Multipart.new(res['params'].merge!(:file => File.new(opts[:file]))).payload.merge!(:digest_auth => @@auth)
      else
        return false
      end
      res.ok? ? Item.new(res) : res
    end
    
    def initialize(attributes = {})
      load(attributes)
    end
    
    def delete
      res = self.class.delete self.href, :digest_auth => @@auth
      res.ok? ? true : res
    end
    
    private
    
    def load(attributes = {})
      attributes.each do |key, val|
        self.instance_variable_set("@#{key}", val)
        self.class.send(:define_method, key, proc{self.instance_variable_get("@#{key}")})
      end
    end
        
  end  
  
  class Item < Base ; end

end