module CloudApp
  
  class Account < Base
    
    def self.find
      res = get "/account", :digest_auth => @@auth
      res.ok? ? Account.new(res) : res
    end
    
    def self.create(opts = {})
      res = post "/register", :body => {:user => opts}
      res.ok? ? Account.new(res) : res
    end
    
    def self.update(opts = {})
      res = put "/account", {:body => {:user => opts}, :digest_auth => @@auth}
      res.ok? ? Account.new(res) : res
    end
    
    def self.reset(opts = {})
      res = post "/reset", {:body => {:user => opts}, :digest_auth => @@auth}
      res.ok? ? true : res
    end
        
    attr_reader :id, :email, :domain, :domain_home_page, :private_items,
                :subscribed, :alpha, :created_at, :updated_at, :activated_at
    
    def initialize(attributes = {})
      load(attributes)
    end
    
    def update(opts = {})
      self.class.update opts
    end
    
    def reset(opts = {})
      self.class.reset opts
    end
    
    private
    
    def load(attributes = {})
      attributes.each do |key, val|
        self.instance_variable_set("@#{key}", val)
      end
    end
        
  end
  
end