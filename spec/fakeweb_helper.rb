require 'fakeweb'

FakeWeb.allow_net_connect = false

def stub_file(stub)
  File.join(File.dirname(__FILE__), 'stubs', stub)
end

def fake_it_all
  FakeWeb.clean_registry
  {
    # GET URLs
    :get => {
      /http:\/\/cl.ly\/\w{3,}$/         => File.join('item', 'show'),
      'http://my.cl.ly/items'           => File.join('item', 'all'),
      'http://my.cl.ly/items/new'       => File.join('item', 'new'),
      'http://my.cl.ly/items/s3'        => File.join('item', 'show'),
      'http://my.cl.ly/account'         => File.join('account', 'show')
    },
    # POST URLs
    :post => {
      'http://my.cl.ly/items'           => File.join('item', 'new'),
      'http://f.cl.ly'                  => File.join('item', 'create'),
      'http://my.cl.ly/reset'           => File.join('account', 'reset'),
      'http://my.cl.ly/register'        => File.join('account', 'create')
    },
    # PUT URLs
    :put => {
      /http:\/\/cl.ly\/items\/\w{3,}$/  => File.join('item', 'update'),
      'http://my.cl.ly/account'         => File.join('account', 'update')
    },
    # DELETE URLs
    :delete => {
      /http:\/\/cl.ly\/items\/\w{3,}$/  => File.join('item', 'delete')
    }
  }.
  each do |method, requests|
    requests.each do |url, response|
      FakeWeb.register_uri(method, url, :response => stub_file(response))
    end
  end
end