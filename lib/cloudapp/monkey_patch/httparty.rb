module HTTParty
  
  module ClassMethods
    def digest_auth(u, p)
      default_options[:digest_auth] = {:username => u, :password => p}
    end
  end
  
  class Request
    
    private
    
    def credentials
      options[:basic_auth] || options[:digest_auth]
    end
    
    def username
      credentials[:username]
    end

    def password
      credentials[:password]
    end
    
    def setup_digest_auth
      res = http.head(uri.request_uri, options[:headers])
      if res['www-authenticate'] != nil && res['www-authenticate'].length > 0
        @raw_request.digest_auth(username, password, res)
      end
    end
    
  end
  
end