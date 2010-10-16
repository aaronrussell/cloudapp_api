require 'fakeweb'

def stub_file( file )
  File.join(TEST_DIR, 'fakeweb', file)
end

FakeWeb.allow_net_connect = false

FakeWeb.register_uri :head, %r\^http://(my|f).cl.ly(/items)?\, :response => stub_file('auth.head')
FakeWeb.register_uri :get,  "http://my.cl.ly/items",    :response => stub_file('listing.response')
FakeWeb.register_uri :post, %r|^http://my.cl.ly/items|, :response => stub_file('create_bookmark.response')

FakeWeb.register_uri :get, %r|^http://cl.ly|, :response => stub_file('get_item.response')

FakeWeb.register_uri :delete, "http://my.cl.ly/items/1234", [
  {:response => stub_file('delete.head') },
  {:response => stub_file('404.head')}
]

FakeWeb.register_uri :get,  "http://my.cl.ly/items/new", :response => stub_file('new_item.response')
FakeWeb.register_uri :post, "http://f.cl.ly", :status => ["200", "OK"]
