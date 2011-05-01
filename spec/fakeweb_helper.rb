require 'fakeweb'

FakeWeb.allow_net_connect = false

def stub_file(stub)
  File.join(File.dirname(__FILE__), 'stubs', stub)
end

def fake_it_all
  FakeWeb.clean_registry
  FakeWeb.register_uri :head, %r{http://(my.|f.)?cl.ly(/items)?}, :status => ["200", "OK"]
  FakeWeb.register_uri :post, 'http://f.cl.ly', :status => ["303"], :location => "http://my.cl.ly/items/s3"
  FakeWeb.register_uri :post, 'http://my.cl.ly/reset', :status => ["200", "OK"]
  {
    # GET URLs
    :get => {
      %r{http://cl.ly/\w+}                => File.join('item', 'show'),
      'http://my.cl.ly/items'             => File.join('item', 'index'),
      'http://my.cl.ly/items/new'         => File.join('item', 'new-private'),
      'http://my.cl.ly/items/new?item[private]=true' => File.join('item', 'new'),
      'http://my.cl.ly/items/s3'          => File.join('item', 'show'),
      'http://my.cl.ly/items/s3?item[private]=true' => File.join('item', 'show-private'),
      'http://my.cl.ly/account'           => File.join('account', 'show'),
      'http://my.cl.ly/account/stats'     => File.join('account', 'stats'),
      %r{http://my.cl.ly/gift_cards/\w+}  => File.join('gift_card', 'show')
    },
    # POST URLs
    :post => {
      'http://my.cl.ly/items'             => File.join('item', 'create'),
      'http://my.cl.ly/register'          => File.join('account', 'create')
    },
    # PUT URLs
    :put => {
      %r{http://my.cl.ly/items/\d+}       => File.join('item', 'update'),
      'http://my.cl.ly/account'           => File.join('account', 'update'),
      %r{http://my.cl.ly/gift_cards/\w+}  => File.join('gift_card', 'redeem')
    },
    # DELETE URLs
    :delete => {
      %r{http://my.cl.ly/items/\d+}       => File.join('item', 'delete')
    }
  }.
  each do |method, requests|
    requests.each do |url, response|
      FakeWeb.register_uri(method, url, :response => stub_file(response))
    end
  end
end