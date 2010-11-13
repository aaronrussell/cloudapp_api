require 'fakeweb'
require 'helper/methods'

FakeWeb.allow_net_connect = false

FakeWeb.register_uri :head, %r\^http://(my|f).cl.ly(/items)?\, auth_response
FakeWeb.register_uri :get,  "http://my.cl.ly/items", item_listing_response
FakeWeb.register_uri :post, %r|^http://my.cl.ly/items|, new_bookmark_response

FakeWeb.register_uri :get, %r|^http://cl.ly|, get_item_response

FakeWeb.register_uri :delete, "http://my.cl.ly/items/1234", [ ok_response, not_found_response ]

FakeWeb.register_uri :get,  "http://my.cl.ly/items/new", new_item_response
FakeWeb.register_uri :post, "http://f.cl.ly", ok_response
