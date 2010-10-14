if HTTParty::VERSION <= "0.5.2"
  ["httparty", "net_digest_auth"].each do |inc|
    require File.join(File.dirname(__FILE__), "monkey_patch", inc)
  end
end

module HTTParty
  class Response < HTTParty::BasicObject
    def ok?
      self.code == 200
    end
  end
  
  class Request
    private
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