module CloudApp
  
  # An ActiveResource-like interface through which to interract with CloudApp accounts.
  #
  # @example Create a CloudApp account
  #   CloudApp::Account.create :email => "arthur@dent.com", :password => "towel"
  #
  # @example Most other account actions require authentication first
  #   CloudApp.authenticate "username", "password"
  #
  # @example Usage via the Account class
  #   # View account details
  #   @account = CloudApp::Account.find
  #   
  #   # Change default security
  #   CloudApp::Account.update :private_items => false
  #   
  #   # Change email
  #   CloudApp::Account.update :email => "ford@prefect.com", :current_password => "towel"
  #   
  #   # Change password
  #   CloudApp::Account.update :password => "happy frood", :current_password => "towel"
  #   
  #   # Set custom domain
  #   CloudApp::Account.update :domain => "dent.com", :domain_home_page => "http://hhgproject.org"
  #   
  #   # Forgot password
  #   CloudApp::Account.reset :email => "arthur@dent.com"
  #   
  #   # View account stats
  #   CloudApp::Account.stats
  #
  # @example Usage via the class instance
  #   # Change default security
  #   @account.update :private_items => false
  #   
  #   # Change email
  #   @account.update :email => "ford@prefect.com", :current_password => "towel"
  #   
  #   # Change password
  #   @account.update :password => "happy frood", :current_password => "towel"
  #   
  #   # Set custom domain
  #   @account.update :domain => "dent.com", :domain_home_page => "http://hhgproject.org"
  #   
  #   # Forgot password
  #   @account.reset
  #   
  #   # View account stats
  #   @account.stats
  #
  class Account < Base
    
    # Get the basic details of the authenticated account.
    #
    # Requires authentication.
    #
    # @return [CloudApp::Account]
    def self.find
      res = get "/account", :digest_auth => @@auth
      res.ok? ? Account.new(res) : res
    end
    
    # Create a CloudApp account.
    #
    # @param [Hash] opts options parameters
    # @option opts [String] :email Account email address
    # @option opts [String] :password Account password
    # @option opts [Boolean] :accept_tos Accept CloudApp terms of service
    # @return [CloudApp::Account]
    def self.create(opts = {})
      res = post "/register", :body => {:user => opts}
      res.ok? ? Account.new(res) : res
    end
    
    # Modify the authenticated accounts details. Can change the default security of newly
    # created drops, the accounts email address, password, and custom domain details.
    #
    # Note that when changing email address or password, the current password is required.
    # Also note that to change custom domains requires an account with a Pro subscription.
    #
    # Requires authentication
    #
    # @param [Hash] opts options parameters
    # @option opts [Boolean] :private_items Change default security of new drops
    # @option opts [String] :email Change email address
    # @option opts [String] :password Change password
    # @option opts [String] :current_password Current account password
    # @option opts [String] :domain Set custom domain
    # @option opts [String] :domain_home_page URL to redirect visitors to custom domain's root
    # @return [CloudApp::Account]
    def self.update(opts = {})
      res = put "/account", {:body => {:user => opts}, :digest_auth => @@auth}
      res.ok? ? Account.new(res) : res
    end
    
    # Dispatch an email containing a link to reset the account's password.
    #
    # @param [Hash] opts options parameters
    # @option opts [String] :email Account email address
    # @return [Boolean]
    def self.reset(opts = {})
      res = post "/reset", :body => {:user => opts}
      res.ok? ? true : res
    end
    
    # Get the total number of drops created and total views for all drops.
    #
    # Requires authentication.
    # 
    # @return [Hash]
    def self.stats
      res = get "/account/stats", :digest_auth => @@auth
      res.ok? ? res.symbolize_keys! : res
    end
        
    attr_reader :id, :email, :domain, :domain_home_page, :private_items,
                :subscribed, :alpha, :created_at, :updated_at, :activated_at
    
    # Create a new CloudApp::Account object.
    #
    # Only used internally
    #
    # @param [Hash] attributes
    # @param [CloudApp::Account]
    def initialize(attributes = {})
      load(attributes)
    end
    
    # Modify the authenticated accounts details. Can change the default security of newly
    # created drops, the accounts email address, password, and custom domain details.
    #
    # Note that when changing email address or password, the current password is required.
    # Also note that to change custom domains requires an account with a Pro subscription.
    #
    # @param [Hash] opts options parameters
    # @option opts [Boolean] :private_items Change default security of new drops
    # @option opts [String] :email Change email address
    # @option opts [String] :password Change password
    # @option opts [String] :current_password Current account password
    # @option opts [String] :domain Set custom domain
    # @option opts [String] :domain_home_page URL to redirect visitors to custom domain's root
    # @return [CloudApp::Account]
    def update(opts = {})
      self.class.update opts
    end
    
    # Dispatch an email containing a link to reset the account's password.
    #
    # @param [Hash] opts options parameters
    # @option opts [String] :email Account email address
    # @return [Boolean]
    def reset
      self.class.reset :email => self.email
    end
    
    # Get the total number of drops created and total views for all drops.
    # 
    # @return [Hash]
    def stats
      self.class.stats
    end
    
  end
  
end