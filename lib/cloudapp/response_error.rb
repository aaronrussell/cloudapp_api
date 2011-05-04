module CloudApp
  
  # Error raised on a bad response
  class ResponseError < StandardError
    
    attr_reader :response, :code, :errors
    
    # Instantiate an instance of CloudApp::ResponseError
    #
    # Only used internally
    #
    # @param [HTTParty::Response] res
    # @return [CloudApp::ResponseError]
    def initialize(res)
      @response = res.response
      @code     = res.code
      @errors   = parse_errors(res.parsed_response)
    end
    
    # Returns error code and message
    #
    # @return [String]
    def to_s
      puts "#{code} #{response.msg}"
    end
    
    private
    
    def parse_errors(errors)
      return case errors
        when Hash:    errors.collect{|k,v| "#{k} #{v}"}
        when String:  [errors]
        when Array:   errors
        else []
      end
    end
    
  end
  
end