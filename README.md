# CloudApp API

[![Build Status](https://travis-ci.org/aaronrussell/cloudapp_api.png)](https://travis-ci.org/aaronrussell/cloudapp_api)
[![Code Climate](https://codeclimate.com/github/aaronrussell/cloudapp_api.png)](https://codeclimate.com/github/aaronrussell/cloudapp_api)
[![Coverage Status](https://coveralls.io/repos/aaronrussell/cloudapp_api/badge.png?branch=master)](https://coveralls.io/r/aaronrussell/cloudapp_api)

A simple Ruby wrapper for the [CloudApp API](http://support.getcloudapp.com/faqs/developers/api). Uses [HTTParty](http://github.com/jnunemaker/httparty) with a simple ActiveResource-like interface.

Two interfaces are provided for interacting with the CloudApp API. The first is a ActiveResource-like interface, directly calling methods on the Drop and Account classes. The second option is to interact through a Client interface.

* [Familiarise yourself with the documentation](http://rubydoc.info/github/aaronrussell/cloudapp_api/)

## Installation

To install as a Gem:

    sudo gem install cloudapp_api

## Authentication

Authentication is necessary for most actions, the only exceptions being when creating a new Account or querying a specific Drop.

    CloudApp.authenticate "email@address.com", "password"

## Drops

* Documentation - {CloudApp::Drop}

---

### Usage via the Drop class

    # Find a single drop by it's slug
    @drop = CloudApp::Drop.find "2wr4"
    
    # Get a list of all drops
    @drops = CloudApp::Drop.all
    
    # Create a new bookmark
    @drop = CloudApp::Drop.create :bookmark, :name => "CloudApp", :redirect_url => "http://getcloudapp.com"
    
    # Create multiple bookmarks
    bookmarks = [
      { :name => "Authur Dent", :redirect_url => "http://en.wikipedia.org/wiki/Arthur_Dent" },
      { :name => "Zaphod Beeblebrox", :redirect_url => "http://en.wikipedia.org/wiki/Zaphod_Beeblebrox" }
    ]
    @drops = CloudApp::Drop.create :bookmarks, bookmarks
    
    # Upload a file
    @drop = CloudApp::Drop.create :upload, :file => "/path/to/image.png"
    @drop = CloudApp::Drop.create :upload, :file => "/path/to/image.png", :private => true
    
    # Rename a file
    CloudApp::Drop.update "http://my.cl.ly/items/1912565", :name => "Big Screenshot"
    
    # Set a drop's privacy
    CloudApp::Drop.update "http://my.cl.ly/items/1912565", :private => true
    
    # Delete a drop
    CloudApp::Drop.delete "http://my.cl.ly/items/1912565"
 
    # Recover a deleted drop
    CloudApp::Drop.recover "http://my.cl.ly/items/1912565"

### Usage via the class instance

    # Rename a file
    @drop.update :name => "Big Screenshot"
    
    # Set the drop's privacy
    @drop.update :private => true
    
    # Delete a drop
    @drop.delete
 
    # Recover a deleted drop
    @drop.recover

## Drops via a Client instance

* Documentation - {CloudApp::Client}

---

    # Find a single drop by it's slug
    drop = @client.drop "2wr4"
    
    # Get a list of all drops
    drops = @client.all
    
    # Create a new bookmark
    drop = @client.bookmark "http://getcloudapp.com", "CloudApp"
    
    # Create multiple new bookmarks
    bookmarks = [
      { :name => "Authur Dent", :redirect_url => "http://en.wikipedia.org/wiki/Arthur_Dent" },
      { :name => "Zaphod Beeblebrox", :redirect_url => "http://en.wikipedia.org/wiki/Zaphod_Beeblebrox" }
    ]
    drops = @client.bookmark bookmarks
    
    # Upload a file
    drop = @client.upload "/path/to/image.png"
    drop = @client.upload "/path/to/image.png", :private => true
    
    # Rename a file
    @client.rename "2wr4", "Big Screenshot"
    
    # Set a drop's privacy
    @client.privacy "2wr4", true
    
    # Delete an drop
    @client.delete "2wr4"
    
    # Recover a deleted drop
    @client.recover "2wr4"

## Account examples

* Documentation - {CloudApp::Account}

---

    # Create a CloudApp account
    @account = CloudApp::Account.create :email => "arthur@dent.com", :password => "towel"
    
    # View account details
    @account = CloudApp::Account.find
    
    # Forgot password
    CloudApp::Account.reset :email => "arthur@dent.com"
     
    # Change default security
    @account.update :private_items => false
    
    # Change email
    @account.update :email => "ford@prefect.com", :current_password => "towel"
    
    # Change password
    @account.update :password => "happy frood", :current_password => "towel"
    
    # Set custom domain
    @account.update :domain => "dent.com", :domain_home_page => "http://hhgproject.org"
    
    # View account stats
    @account.stats

## Gift cards

* Documentation - {CloudApp::GiftCard}

---

    # View gift card details
    @gift = CloudApp::GiftCard.find "ABC123"
    
    # Apply the gift card
    CloudApp::GiftCard.redeem "ABC123"
      # or
    @gift.redeem

## What's next on the to-do list?

* Refactor the Client interface so can be used with all of the API

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Author & Contributors

* [Aaron Russell](http://www.aaronrussell.co.uk)
* [Christian Nicolai](https://github.com/cmur2)

## Copyright

Copyright (c) 2010 Aaron Russell. See LICENSE for details.
