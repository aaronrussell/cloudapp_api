module CloudApp
  
  # A client interface through which to interract with the CloudApp API.
  # 
  # @example Creating a client instance and set authentication credentials
  #   @client = CloudApp::Client.new
  #   @client.authenticate "username", "password"
  #
  # @example Creating editing and deleting cl.ly items
  #   # Find a single item by it's slug
  #   item = @client.item "2wr4"
  #   
  #   # Get a list of all items
  #   items = @client.all
  #   
  #   # Create a new bookmark
  #   item = @client.bookmark "http://getcloudapp.com", "CloudApp"
  #   
  #   # Create multiple new bookmarks
  #   bookmarks = [
  #     { :name => "Authur Dent", :redirect_url => "http://en.wikipedia.org/wiki/Arthur_Dent" },
  #     { :name => "Zaphod Beeblebrox", :redirect_url => "http://en.wikipedia.org/wiki/Zaphod_Beeblebrox" }
  #   ]
  #   items = @client.bookmark bookmarks
  #   
  #   # Upload a file
  #   item = @client.upload "/path/to/image.png"
  #   item = @client.upload "/path/to/image.png", :private => true
  #   
  #   # Rename a file
  #   @client.rename "2wr4", "Big Screenshot"
  #   
  #   # Set an items privacy
  #   @client.privacy "2wr4", true
  #   
  #   # Delete an item
  #   @client.delete "2wr4"
  #   
  #   # Recover a deleted item
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
    # Finds the item by it's slug id, for example "2wr4".
    #
    # @param [String] id cl.ly slug id
    # @return [CloudApp::Item]
    def item(id)
      Item.find(id)
    end
    
    # Page through your items.
    #
    # Requires authentication.
    #
    # @param [Hash] opts options parameters
    # @option opts [Integer] :page (1) Page number starting at 1
    # @option opts [Integer] :per_page (5) Number of items per page
    # @option opts [String] :type ('image') Filter items by type (image, bookmark, text, archive, audio, video, or unknown)
    # @option opts [Boolean] :deleted (true) Show trashed items
    # @return [Array[CloudApp::Item]]
    def items(opts = {})
      Item.all(opts)
    end
    
    # Create a new cl.ly item by bookmarking one or more links.
    #
    # Requires authentication.
    #
    # @overload bookmark(url, name = "")
    #   @param [String] url url to bookmark
    #   @param [String] name name of bookmark
    # @overload bookmark(opts)
    #   @param [Array] opts array of bookmark option parameters (containing +:name+ and +:redirect_url+)
    # @return [CloudApp::Item]
    def bookmark(*args)
      if args[0].is_a? Array
        Item.create(:bookmarks, args)
      else
        name, url = args[0], (args[1] || "")
        Item.create(:bookmark, {:name => name, :redirect_url => url})
      end
    end
    
    # Create a new cl.ly item by uploading a file.
    #
    # Requires authentication.
    #
    # @param [String] file local path to file
    # @param [optional, Hash] opts options paramaters
    # @option opts [Boolean] :private override the account default privacy setting
    # @return [CloudApp::Item]
    def upload(file, opts = {})
      Item.create(:upload, opts.merge(:file => file))
    end
    
    # Change the name of an item.
    #
    # Finds the item by it's slug id, for example "2wr4".
    #
    # Requires authentication.
    #
    # @param [String] id cl.ly item id
    # @param [String] name new item name
    # @return [CloudApp::Item]
    def rename(id, name = "")
      item = Item.find(id)
      item.class == Item ? item.update(:name => name) : item
    end
    
    # Modify an item with a private URL to have a public URL or vice versa.
    #
    # Finds the item by it's slug id, for example "2wr4".
    #
    # Requires authentication.
    #
    # @param [String] id cl.ly item id
    # @param [Boolean] privacy privacy setting
    # @return [CloudApp::Item]
    def privacy(id, privacy = false)
      item = Item.find(id)
      item.class == Item ? item.update(:private => privacy) : item
    end
    
    # Send an item to the trash.
    #
    # Finds the item by it's slug id, for example "2wr4".
    #
    # Requires authentication.
    #
    # @param [String] id cl.ly item id
    # @return [CloudApp::Item]
    def delete(id)
      item = Item.find(id)
      item.class == Item ? item.delete : item
    end
    
    # Recover a deleted item from the trash.
    #
    # Finds the item by it's slug id, for example "2wr4".
    #
    # Requires authentication.
    #
    # @param [String] id cl.ly item id
    # @return [CloudApp::Item]
    def recover(id)
      item = Item.find(id)
      item.class == Item ? item.recover : item
    end
        
  end
  
end
