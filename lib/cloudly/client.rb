module Cloudly
  
  class Client
    
    def initialize(opts = {})
      if opts[:username] && opts[:password]
        Base.authenticate(opts[:username], opts[:password])
      end
    end
    
    def authenticate(username, password)
      Base.authenticate(username, password)
    end
    
    def item(id)
      Item.find(id)
    end
    
    def items(opts = {})
      Item.all(opts)
    end
  
    def bookmark(url, name = "")
      Item.create(:bookmark, :item => {:name => name, :redirect_url => url})
    end
    
    def upload(file)
      Item.create(:upload, :data => file)
    end
  
    def delete(id)
      Item.find(id).delete
    end
        
  end
  
end