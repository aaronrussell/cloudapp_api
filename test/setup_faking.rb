require 'fakeweb'

def stub_file( file )
  File.join(TEST_DIR, 'fakeweb', file)
end

def hash2json( hash )
  s = hash.map do |k,v|
    v = case v.class
    when ::Array then
      array2json(v)
    else
      v
    end
    "\"#{k}\":\"#{v.nil? ? 'nil' : v}\""
  end
  "{#{s.join(",")}}"
end

def array2json( array )
  array.to_s
end

def ok_response
  { :status => ["200", "OK"] }
end

def auth_response
  { :status => ["401", "Unauthorized"] }
end

def not_found_response
  { :status => ["404", "Not Found"] }
end

def get_item_response
  {
    :content_type => "application/json; charset=utf-8",
    :body => hash2json({
      "href"=>"http://my.cl.ly/items/1234",
      "content_url"=>"http://cl.ly/rAnD/content",
      "name"=>"CloudApp",
      "redirect_url"=>"http://cloudapp.com",
      "created_at"=>"2010-10-15T17:01:33Z",
      "updated_at"=>"2010-10-15T18:56:11Z",
      "public_slug"=>"rAnD",
      "private"=>false,
      "deleted_at"=>nil,
      "url"=>"http://cl.ly/rAnD",
      "view_counter"=>0,
      "remote_url"=>nil,
      "last_viewed"=>nil,
      "icon"=>"http://my.cl.ly/images/item_types/bookmark.png",
      "owner_id"=>28100,
      "id"=>1234,
      "private_slug"=>nil,
      "item_type"=>"bookmark"
    })
  }.merge(ok_response)
end

def new_item_response
  {

  }
end

FakeWeb.allow_net_connect = false

FakeWeb.register_uri :head, %r\^http://(my|f).cl.ly(/items)?\, auth_response
FakeWeb.register_uri :get,  "http://my.cl.ly/items", :response => stub_file('listing.response')
FakeWeb.register_uri :post, %r|^http://my.cl.ly/items|, :response => stub_file('create_bookmark.response')

FakeWeb.register_uri :get, %r|^http://cl.ly|, get_item_response

FakeWeb.register_uri :delete, "http://my.cl.ly/items/1234", [ ok_response, not_found_response ]

FakeWeb.register_uri :get,  "http://my.cl.ly/items/new", :response => stub_file('new_item.response')
FakeWeb.register_uri :post, "http://f.cl.ly", ok_response
