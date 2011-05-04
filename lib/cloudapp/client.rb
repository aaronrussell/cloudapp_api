module CloudApp
  
  # A client interface through which to interract with the CloudApp API.
  # 
  # @example Creating a client instance and set authentication credentials
  #   @client = CloudApp::Client.new
  #   @client.authenticate "username", "password"
  #
  # @example Creating editing and deleting drops
  #   # Find a single drop by it's slug
  #   drop = @client.drop "2wr4"
  #   
  #   # Get a list of all drops
  #   drops = @client.all
  #   
  #   # Create a new bookmark
  #   drop = @client.bookmark "http://getcloudapp.com", "CloudApp"
  #   
  #   # Create multiple new bookmarks
  #   bookmarks = [
  #     { :name => "Authur Dent", :redirect_url => "http://en.wikipedia.org/wiki/Arthur_Dent" },
  #     { :name => "Zaphod Beeblebrox", :redirect_url => "http://en.wikipedia.org/wiki/Zaphod_Beeblebrox" }
  #   ]
  #   drops = @client.bookmark bookmarks
  #   
  #   # Upload a file
  #   drop = @client.upload "/path/to/image.png"
  #   drop = @client.upload "/path/to/image.png", :private => true
  #   
  #   # Rename a file
  #   @client.rename "2wr4", "Big Screenshot"
  #   
  #   # Set a drop's privacy
  #   @client.privacy "2wr4", true
  #   
  #   # Delete an drop
  #   @client.delete "2wr4"
  #   
  #   # Recover a deleted drop
  #   @client.recover "2wr4"
  #
  class Client
    
    # Creates a new CloudApp::Client instance.
    #
    # You can pass +:username+ and +:password+ parameters to the call.
    #
    # @param [Hash] opts authentication credentials.
    # @option opts [String] :username cl.ly username
    # @option opts [String] :password cl.ly username
    # @return [CloudApp::Client]
    def initialize(opts = {})
      if opts[:username] && opts[:password]
        Base.authenticate(opts[:username], opts[:password])
      end
    end
    
    # Sets the authentication credentials in a class variable.
    #
    # @param [String] username cl.ly username
    # @param [String] password cl.ly password
    # @return [Hash] authentication credentials
    def authenticate(username, password)
      Base.authenticate(username, password)
    end
    
    # Get metadata about a cl.ly URL like name, type, or view count.
    #
    # Finds the drop by it's slug id, for example "2wr4".
    #
    # @param [String] id cl.ly slug id
    # @return [CloudApp::Drop]
    def drop(id)
      Drop.find(id)
    end
    
    alias_method :item, :drop
    
    # Page through your drops.
    #
    # Requires authentication.
    #
    # @param [Hash] opts options parameters
    # @option opts [Integer] :page (1) Page number starting at 1
    # @option opts [Integer] :per_page (5) Number of items per page
    # @option opts [String] :type ('image') Filter items by type (image, bookmark, text, archive, audio, video, or unknown)
    # @option opts [Boolean] :deleted (true) Show trashed drops
    # @return [Array[CloudApp::Drop]]
    def drops(opts = {})
      Drop.all(opts)
    end
    
    alias_method :items, :drops
    
    # Create one or more new bookmark drops.
    #
    # Requires authentication.
    #
    # @overload bookmark(url, name = "")
    #   @param [String] url url to bookmark
    #   @param [String] name name of bookmark
    # @overload bookmark(opts)
    #   @param [Array] opts array of bookmark option parameters (containing +:name+ and +:redirect_url+)
    # @return [CloudApp::Drop]
    def bookmark(*args)
      if args[0].is_a? Array
        Drop.create(:bookmarks, args)
      else
        name, url = args[0], (args[1] || "")
        Drop.create(:bookmark, {:name => name, :redirect_url => url})
      end
    end
    
    # Create a new drop by uploading a file.
    #
    # Requires authentication.
    #
    # @param [String] file local path to file
    # @param [optional, Hash] opts options paramaters
    # @option opts [Boolean] :private override the account default privacy setting
    # @return [CloudApp::Drop]
    def upload(file, opts = {})
      Drop.create(:upload, opts.merge(:file => file))
    end
    
    # Change the name of the drop.
    #
    # Finds the drop by it's slug id, for example "2wr4".
    #
    # Requires authentication.
    #
    # @param [String] id drop id
    # @param [String] name new drop name
    # @return [CloudApp::Drop]
    def rename(id, name = "")
      drop = Drop.find(id)
      drop.update(:name => name)
    end
    
    # Modify a drop with a private URL to have a public URL or vice versa.
    #
    # Finds the drop by it's slug id, for example "2wr4".
    #
    # Requires authentication.
    #
    # @param [String] id drop id
    # @param [Boolean] privacy privacy setting
    # @return [CloudApp::Drop]
    def privacy(id, privacy = false)
      drop = Drop.find(id)
      drop.update(:private => privacy)
    end
    
    # Send the drop to the trash.
    #
    # Finds the drop by it's slug id, for example "2wr4".
    #
    # Requires authentication.
    #
    # @param [String] id drop id
    # @return [CloudApp::Drop]
    def delete(id)
      drop = Drop.find(id)
      drop.delete
    end
    
    # Recover a deleted drop from the trash.
    #
    # Finds the drop by it's slug id, for example "2wr4".
    #
    # Requires authentication.
    #
    # @param [String] id drop id
    # @return [CloudApp::Drop]
    def recover(id)
      drop = Drop.find(id)
      drop.recover
    end
        
  end
  
end
