module CloudApp
  
  class Account < Base
    
    # Get the basic details of the authenticated account.
    # Requires authentication.
    # @return [CloudApp::Account]
    def self.find
      res = get "/account", :digest_auth => @@auth
      res.ok? ? Account.new(res) : res
    end
    
    # Create a CloudApp account.
    # @example Provide a user details param
    #   { :email => "arthur@dent.com", :password => "towel" }
    # @param [Hash] of user credentials
    # @return [CloudApp::Account]
    def self.create(opts = {})
      res = post "/register", :body => {:user => opts}
      res.ok? ? Account.new(res) : res
    end
    
    # Modify the authenticated accounts details. Can change the default security of newly
    # created items, the accounts email address, password, and custom domain details.
    # @example Options for changing default security of new items
    #   { :private_items => false }
    # @example Options for changing email address
    #   { :email => "ford@prefect.com", :current_password => "towel" }
    # @example Options for modifying password
    #   { :password => "happy frood", :current_password => "towel" }
    # @example Options for changing custom domain
    #   { :domain => "dent.com", :domain_home_page => "http://hhgproject.org" }
    # Note that to custom domains requires and account with a Pro subscription.
    # Requires authentication.
    # @param [Hash] account parameters
    # @return [CloudApp::Account]
    def self.update(opts = {})
      res = put "/account", {:body => {:user => opts}, :digest_auth => @@auth}
      res.ok? ? Account.new(res) : res
    end
    
    # Dispatch an email containing a link to reset the account's password.
    # @example Requires the account email address in a hash
    #   { :email => "arthur@dent.com" }
    # @param [Hash] account credentials
    # @return [Boolean]
    def self.reset(opts = {})
      res = post "/reset", :body => {:user => opts}
      res.ok? ? true : res
    end
        
    attr_reader :id, :email, :domain, :domain_home_page, :private_items,
                :subscribed, :alpha, :created_at, :updated_at, :activated_at
    
    # Create a new CloudApp::Account object.
    # Only used internally
    # @param [Hash] attributes
    # @param [CloudApp::Account]
    def initialize(attributes = {})
      load(attributes)
    end
    
    # Modify the authenticated accounts details. Can change the default security of newly
    # created items, the accounts email address, password, and custom domain details.
    # @example Options for changing default security of new items
    #   { :private_items => false }
    # @example Options for changing email address
    #   { :email => "ford@prefect.com", :current_password => "towel" }
    # @example Options for modifying password
    #   { :password => "happy frood", :current_password => "towel" }
    # @example Options for changing custom domain
    #   { :domain => "dent.com", :domain_home_page => "http://hhgproject.org" }
    # Note that to custom domains requires and account with a Pro subscription.
    # Requires authentication.
    # @param [Hash] account parameters
    # @return [CloudApp::Account]
    def update(opts = {})
      self.class.update opts
    end
    
    # Dispatch an email containing a link to reset the account's password.
    # @return [Boolean]
    def reset
      self.class.reset :email => self.email
    end
    
  end
  
end