require 'fakeweb'

def stub_file( file )
  File.join(TEST_DIR, 'fakeweb', file)
end

FakeWeb.allow_net_connect = false

FakeWeb.register_uri :head, %r|^http://my.cl.ly/items|, :response => stub_file('auth.head')
FakeWeb.register_uri :get,  "http://my.cl.ly/items",    :response => stub_file('listing.response')
FakeWeb.register_uri :post, "http://my.cl.ly/items",    :response => stub_file('create_bookmark.response')
