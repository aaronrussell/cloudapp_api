if HTTParty::VERSION <= "0.5.2"
  ["httparty", "net_digest_auth"].each do |inc|
    require File.join(File.dirname(__FILE__), "monkey_patch", inc)
  end
end

module HTTParty
  class Response < HTTParty::BasicObject
    def ok?
      @code == 200
    end
  end
end