require "mime/types"

module CloudApp
  
  # TODO - Document the Multipart Class
  class Multipart #:nodoc:
    
    EOL = "\r\n"
    
    def initialize(params)
      @params = params
      file = @params.delete(:file)
      bound = "--#{boundary}"
      @body = bound + EOL
      @params.each do |key, val|
        @body += create_regular_field(key, val)
        @body += EOL + bound + EOL
      end
      @body += create_file_field(file)
      @body += EOL + bound + "--#{EOL}"
    end
    
    def payload
      {
        :headers => {"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
        :body => @body
      }
    end
    
    def boundary
      @boundary ||= "#{HEADERS["User-Agent"]}.#{Array.new(16/2) { rand(256) }.pack("C*").unpack("H*").first}"
    end
    
    def create_regular_field(key, val)
      %Q{Content-Disposition: form-data; name="#{key}"} + EOL + EOL + val
    end
    
    def create_file_field(file)
      %Q{Content-Disposition: form-data; name="file"; filename="#{File.basename(file.path)}"} + EOL +
        "Content-Type: #{mime_for(file.path)}" + EOL + EOL +
        file.read 
    end
    
    def mime_for(path)
      (MIME::Types.type_for(path)[0] || MIME::Types["application/octet-stream"][0]).simplified
    end
    
  end
  
end