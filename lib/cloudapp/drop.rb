module CloudApp
  
  # An ActiveResource-like interface through which to interract with CloudApp drops.
  #
  # @example Gets started by Authenticating
  #   CloudApp.authenticate "username", "password"
  #
  # @example Usage via the Drop class
  #   # Find a single drop by it's slug
  #   @drop = CloudApp::Drop.find "2wr4"
  #   
  #   # Get a list of all drops
  #   @drops = CloudApp::Drop.all
  #   
  #   # Create a new bookmark
  #   @drop = CloudApp::Drop.create :bookmark, :name => "CloudApp", :redirect_url => "http://getcloudapp.com"
  #   
  #   # Create multiple bookmarks
  #   bookmarks = [
  #     { :name => "Authur Dent", :redirect_url => "http://en.wikipedia.org/wiki/Arthur_Dent" },
  #     { :name => "Zaphod Beeblebrox", :redirect_url => "http://en.wikipedia.org/wiki/Zaphod_Beeblebrox" }
  #   ]
  #   @drops = CloudApp::Drop.create :bookmarks, bookmarks
  #   
  #   # Upload a file
  #   @drop = CloudApp::Drop.create :upload, :file => "/path/to/image.png"
  #   @drop = CloudApp::Drop.create :upload, :file => "/path/to/image.png", :private => true
  #   
  #   # Rename a file
  #   CloudApp::Drop.update "http://my.cl.ly/items/1912565", :name => "Big Screenshot"
  #   
  #   # Set a drop's privacy
  #   CloudApp::Drop.update "http://my.cl.ly/items/1912565", :private => true
  #   
  #   # Delete a drop
  #   CloudApp::Drop.delete "http://my.cl.ly/items/1912565"
  #
  #   # Recover a deleted drop
  #   CloudApp::Drop.recover "http://my.cl.ly/items/1912565"
  #
  # @example Usage via the class instance
  #   # Rename a file
  #   @drop.update :name => "Big Screenshot"
  #   
  #   # Set the drop's privacy
  #   @drop.update :private => true
  #   
  #   # Delete a drop
  #   @drop.delete
  #
  #   # Recover a deleted drop
  #   @drop.recover
  #
  class Drop < Base
    
    # Get metadata about a cl.ly URL like name, type, or view count.
    #
    # Finds the drop by it's slug id, for example "2wr4".
    #
    # @param [String] id cl.ly slug id
    # @return [CloudApp::Drop]
    def self.find(id)
      res = get "http://cl.ly/#{id}"
      res.ok? ? Drop.new(res) : res
    end
    
    # Page through your drops.
    #
    # Requires authentication.
    #
    # @param [Hash] opts options parameters
    # @option opts [Integer] :page Page number starting at 1
    # @option opts [Integer] :per_page Number of items per page
    # @option opts [String] :type Filter items by type (image, bookmark, text, archive, audio, video, or unknown)
    # @option opts [Boolean] :deleted Show trashed drops
    # @return [Array[CloudApp::Drop]]
    def self.all(opts = {})
      res = get "/items", {:query => (opts.empty? ? nil : opts), :digest_auth => @@auth}
      res.ok? ? res.collect{|i| Drop.new(i)} : res
    end
    
    # Create a new drop. Multiple bookmarks can be created at once by
    # passing an array of bookmark options parameters.
    #
    # Requires authentication.
    #
    # @param [Symbol] kind type of drop (can be +:bookmark+, +:bookmarks+ or +:upload+)
    # @overload self.create(:bookmark, opts = {})
    #   @param [Hash] opts options paramaters
    #   @option opts [String] :name Name of bookmark (only required for +:bookmark+ kind)
    #   @option opts [String] :redirect_url Redirect URL (only required for +:bookmark+ kind)
    # @overload self.create(:bookmarks, bookmarks)
    #   @param [Array] bookmarks array of bookmark option parameters (containing +:name+ and +:redirect_url+)
    # @overload self.create(:upload, opts = {})
    #   @param [Hash] opts options paramaters
    #   @option opts [String] :file Path to file (only required for +:upload+ kind)
    #   @option opts [Boolean] :private override the account default privacy setting
    # @return [CloudApp::Drop]
    def self.create(kind, opts = {})
      case kind
      when :bookmark
        res = post "/items", {:body => {:item => opts}, :digest_auth => @@auth}
      when :bookmarks
        res = post "/items", {:body => {:items => opts}, :digest_auth => @@auth}
      when :upload
        r = get "/items/new", {:query => ({:item => {:private => opts[:private]}} if opts.has_key?(:private)), :digest_auth => @@auth}
        return r unless r.ok?
        res = post r['url'], Multipart.new(r['params'].merge!(:file => File.new(opts[:file]))).payload.merge!(:digest_auth => @@auth)
      else
        # TODO raise an error
        return false
      end
      res.ok? ? (res.is_a?(Array) ? res.collect{|i| Drop.new(i)} : Drop.new(res)) : res
    end
    
    # Modify a drop. Can currently modify it's name or security setting by passing parameters.
    #
    # Requires authentication.
    #
    # @param [String] href href attribute of drop
    # @param [Hash] opts options paramaters
    # @option opts [String] :name for renaming the drop
    # @option opts [Boolean] :privacy set drop privacy
    # @return [CloudApp::Drop]
    def self.update(href, opts = {})
      res = put href, {:body => {:item => opts}, :digest_auth => @@auth}
      res.ok? ? Drop.new(res) : res
    end
    
    # Send a drop to the trash.
    #
    # Requires authentication.
    #
    # @param [String] href href attribute of the drop
    # @return [CloudApp::Drop]
    def self.delete(href)
      # Use delete on the Base class to avoid recursion
      res = Base.delete href, :digest_auth => @@auth
      res.ok? ? Drop.new(res) : res
    end
    
    # Recover a drop from the trash.
    #
    # Requires authentication.
    #
    # @param [String] href href attribute of the drop
    # @return [CloudApp::Drop]
    def self.recover(href)
      res = put href, {:body => {:deleted => true, :item => {:deleted_at => nil}}, :digest_auth => @@auth}
      res.ok? ? Drop.new(res) : res
    end
    
    attr_reader :href, :name, :private, :url, :content_url, :item_type, :view_counter,
                :icon, :remote_url, :redirect_url, :created_at, :updated_at, :deleted_at
    
    # Create a new CloudApp::Drop object.
    #
    # Only used internally.
    #
    # @param [Hash] attributes
    # @param [CloudApp::Drop]
    def initialize(attributes = {})
      load(attributes)
    end
    
    # Modify the drop. Can currently modify it's name or security setting by passing parameters.
    #
    # @param [Hash] opts options paramaters
    # @option opts [String] :name for renaming the drop
    # @option opts [Boolean] :privacy set the drop's privacy
    # @return [CloudApp::Drop]
    def update(opts = {})
      self.class.update self.href, opts
    end
    
    # Send the drop to the trash.
    #
    # @return [CloudApp::Drop]
    def delete
      self.class.delete self.href
    end
    
    # Recover the drop from the trash.
    #
    # @return [CloudApp::Drop]
    def recover
      self.class.recover self.href
    end
        
  end
  
  # The Item class is now deprecated in favour of the Drop class.
  # For legacy purposes you can still use the Item class but it is recommended you
  # update your code to use the Drop class to ensure future compatibility.
  class Item < Drop; end
  
end