# CloudApp API

A simple Ruby wrapper for the [CloudApp API](http://support.getcloudapp.com/faqs/developers/api). Uses [HTTParty](http://github.com/jnunemaker/httparty) with a simple ActiveResource-like interface.

Two interfaces are provided for interacting with the CloudApp API. The first is a ActiveResource-like interface, directly calling methods on the Item and Account class. The second option is to interact through a Client interface.

* [Familiarise yourself with the documentation](http://rubydoc.info/github/aaronrussell/cloudapp_api/)

## Installation

To install as a Gem:

    sudo gem install cloudapp_api

## Authentication

Authentication is necessary for most actions, the only exceptions being when creating a new Account or querying a specific Item.

    CloudApp.authenticate "email@address.com", "password"

## Item examples

* Documentation - {CloudApp::Item}

---

### Usage via the Item class
    # Find a single item by it's slug
    item = CloudApp::Item.find "2wr4"
  
    # Get a list of all items
    items = CloudApp::Item.all
  
    # Create a new bookmark
    item = CloudApp::Item.create :bookmark, :name => "CloudApp", :redirect_url => "http://getcloudapp.com"
  
    # Upload a file
    item = CloudApp::Item.create :upload, :file => "/path/to/image.png"
  
    # Rename a file
    CloudApp::Item.update "http://my.cl.ly/items/1912565", :name => "Big Screenshot"
  
    # Set an items privacy
    CloudApp::Item.update "http://my.cl.ly/items/1912565", :private => true
  
    # Delete an item
    CloudApp::Item.delete "http://my.cl.ly/items/1912565"

### Usage via an Item instance
    # Rename a file
    @item.update :name => "Big Screenshot"
  
    # Set an items privacy
    @item.update :private => true
  
    # Delete an item
    @tem.delete

## Usage via a Client instance

* Documentation - {CloudApp::Client}

---

    # Create a Client instance
    @client = CloudApp::Client.new
    
    # Find a single item by it's slug
    item = @client.item "2wr4"
    
    # Get a list of all items
    items = @client.all
    
    # Create a new bookmark
    item = @client.bookmark "http://getcloudapp.com", "CloudApp"
    
    # Upload a file
    item = @client.upload "/path/to/image.png"
    
    # Rename a file
    @client.rename "2wr4", "Big Screenshot"
    
    # Set an items privacy
    @client.privacy "2wr4", true
    
    # Delete an item
    @client.delete "2wr4"

## Account examples

* Documentation - {CloudApp::Account}

---

    # Create a CloudApp account
    @account = CloudApp::Account.create :email => "arthur@dent.com", :password => "towel"
    
    # Forgot password
    CloudApp::Account.reset :email => "arthur@dent.com"
    
    # View details of authenticated account
    @account = CloudApp::Account.find
    
    # Change default security
    @account.update :private_items => false
    
    # Change email
    @account.update :email => "ford@prefect.com", :current_password => "towel"
    
    # Change password
    @account.update :password => "happy frood", :current_password => "towel"
    
    # Set custom domain
    @account.update :domain => "dent.com", :domain_home_page => "http://hhgproject.org"
    

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Author & Contributors

* [Aaron Russell](http://www.aaronrussell.co.uk)

## Copyright

Copyright (c) 2010 Aaron Russell. See LICENSE for details.
