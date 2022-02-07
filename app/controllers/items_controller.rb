class ItemsController < ApplicationController


  def index
    # つけないと動かない　なぜ
    require 'net/http'
    # require 'uri'

    # params = URI.encode_www_form({created: >2022-1-31})
    params = "2022-1-31"
    uri = URI.parse("https://qiita.com/api/v2/items?page=10&per_page=10&query=created:>#{params}")
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    @title1 = result[0]["title"]
    @created_at1 = result[0]["created_at"]
    @lgtm1 = result[0]["likes_count"]

    @title2 = result[1]["title"]
    @created_at2 = result[1]["created_at"]
    @lgtm2 = result[1]["likes_count"]

    @title3 = result[2]["title"]
    @created_at3 = result[2]["created_at"]
    @lgtm3 = result[2]["likes_count"]
    # :
    # :
    
  end
end
