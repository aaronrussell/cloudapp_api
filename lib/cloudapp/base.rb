require "httparty"

module CloudApp
      
  class Base
    
    include HTTParty
    base_uri "my.cl.ly"
    headers "Accept" => "application/json", "Content-Type" => "application/json"
    format :json
    
    def self.authenticate(username, password)
      @@auth = {:username => username, :password => password}
    end
    
    def self.find(id)
      res = get("http://cl.ly/#{id}")
      res.ok? ? Item.new(res) : res
    end
    
    def self.all(opts = {})
      res = get("/items", opts.merge!(:digest_auth => @@auth))
      res.ok? ? res.collect{|i| Item.new(i)} : res
    end
    
    def self.create(kind, opts = {})
      case kind
      when :bookmark
        res = post "/items", {:digest_auth => @@auth, :query => opts}
        res.ok? ? Item.new(res) : res
      when :file
        res = get "/items/new", {:digest_auth => @@auth}
        return res unless res.ok?
        res = post res['url'], {
          :headers => {"Content-Type" => "multipart/form-data"},
          :params => res['params'].merge!(:file => "@#{opts[:path]}")
        }
        res.ok? ? Item.new(res) : res
      else
        false
      end
    end
    
    attr_accessor :attributes
    
    def initialize(attributes = {})
      @attributes
      load(attributes)
    end
    
    def delete
      res = self.class.delete(self.href, :digest_auth => @@auth)
      res.ok? ? true : res
    end
    
    def load(attributes = {})
      attributes.each do |key, val|
        self.instance_variable_set("@#{key}", val)
        self.class.send(:define_method, key, proc{self.instance_variable_get("@#{key}")})
      end
    end
        
  end  
  
  class Item < Base ; end

end