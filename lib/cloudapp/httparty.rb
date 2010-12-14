require "json"

module HTTParty #:nodoc:
  
  class Response < HTTParty::BasicObject #:nodoc:
    def ok?
      [200, 201, 202].include?(self.code)
    end
  end
  
  class Request #:nodoc:
    
    private
    
    def body
      options[:body].is_a?(Hash) ? options[:body].to_json : options[:body]
    end
    
    def setup_raw_request
      # This is a cloudapp hack to ensure the correct headers are set on redirect from S3
      if @redirect
        options[:headers] = CloudApp::HEADERS
        options[:query] = {}
        options[:body] = {}
      end
      @raw_request = http_method.new(uri.request_uri)
      @raw_request.body = body if body
      @raw_request.initialize_http_header(options[:headers])
      @raw_request.basic_auth(username, password) if options[:basic_auth]
      setup_digest_auth if options[:digest_auth]
    end
    
  end
  
end