require 'json'
require 'json/add/rails'

def random_slug
  slugs = ['3yH9', '4p3K', '2pEF']
  slugs[ rand(slugs.size) ]
end

def build_item( params = {} )
  params = {
    :type => 'image',
    :public_slug => random_slug
  }.merge(params)
  {
    "href"=>"http://my.cl.ly/items/1234",
    "content_url"=>"http://cl.ly/#{params[:public_slug]}/content",
    "redirect_url" => params[:type] == 'bookmark' ? "http://cloudapp.com" : nil,
    "public_slug" => params[:public_slug],
    "private"=>false,
    "deleted_at"=>nil,
    "url"=>"http://cl.ly/#{params[:public_slug]}",
    "remote_url" => params[:type] != 'bookmark' ? "http://f.cl.ly/items/1d1a7310f29c96/Item_Name.png" : nil,
    "last_viewed"=>nil,
    "icon"=>"http://my.cl.ly/images/item_types/#{params[:type]}.png",
    "item_type" => params[:type]
  }
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

def json_response
  {:content_type => "application/json; charset=utf-8"}.merge(ok_response)
end

def item_listing_response
  {
    :body => [build_item, build_item, build_item(:type=>'bookmark')].to_json
  }.merge(json_response)
end

def get_item_response
  {
    :body => build_item.to_json
  }.merge(json_response)
end

def new_item_response
  {
    :body => {
      "url" =>"http://f.cl.ly",
      "params" => {
        "success_action_redirect" => "http://my.cl.ly/items/s3",
        "acl" => "public-read",
        "AWSAccessKeyId" => "AKIABHXGSHSBEOFS6Q",
        "key" => "items/dcb0aa186du4450478f0/${filename}",
        "signature" => "Cm5S8VMo8fcyi4heVXqRqpYj6sE=",
        "policy" => "eyJRoLXJhbmdlIiwwLDI2MjE0NDAeSIsIml0ZW1zL2RjYjBhYTE1Y2NjNDQ1MDQ3OGYwLyJdXX0=",
      }
    }.to_json
  }.merge(json_response)
end

def new_bookmark_response
  {
    :body => build_item(:type => 'bookmark' ).to_json
  }.merge(json_response)
end
