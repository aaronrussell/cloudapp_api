# CloudApp API

A simple Ruby wrapper for the [CloudApp API](http://support.getcloudapp.com/faqs/developers/api). Uses [HTTParty](http://github.com/jnunemaker/httparty) with a simple ActiveResource-like interface.

## TODO

* Add tests
* Improve the docs

## Installation

To install as a Gem:

    sudo gem install cloudapp_api

## Usage

### Authentication

Authentication isn't necessary if you are just attempting to find an individual item. However, if you are trying to create, delete or list all items, you must authenticate.

    CloudApp.authenticate "email@address.com", "password"

### Initialize client interface

If you are using the client interface, you must create a client instance.

    # Optionally you can pass a hash containing :username and :password to authenticate.
    
    client = CloudApp::Client.new opts

### View an item by short URL

    short_url = "19xM"
    
    @item = client.item short_url
    
    # or ..
    
    @item = CloudApp::Item.find short_url

### List items
    
    # Allowed params
    #   :page => 1        # page number starting at 1
    #   :per_page => 5    # number of items per page
    #   :type => "image"  # filter items by type
    #                       (image, bookmark, text, archive, audio, video, or unknown)
    #   :deleted => true  # show trashed items
    
    @items = client.items params
    
    # or ..
    
    @items = CloudApp::Item.all params

### Create a bookmark

    @item = client.bookmark url, name
    
    # or ..
    
    @item = CloudApp::Item.create :bookmark, {:name => name, :redirect_url => url}
    
### Upload a file

    @item = client.upload file_name
    
    # or ..
    
    @item = CloudApp::Item.create :upload, {:file => file_name}
    
### Delete an item

    client.delete short_url
    
    # or ..
    
    @item.delete

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Author

* [Aaron Russell](http://www.aaronrussell.co.uk)

## Copyright

Copyright (c) 2010 Aaron Russell. See LICENSE for details.
