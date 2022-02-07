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

    # 1個目のみ
    @title = result[0]["title"]
    @name= result[0]["user"]["name"]
    @created_at = result[0]["created_at"]
    @lgtm = result[0]["likes_count"]
    # 1個目のみ
    @tag = result[0]["tags"]

    @tag_array= []

    # 配列で取得したい
    @tag.each { |tag|
      @tags = tag["name"]
      @tag_array.append(@tags)
    }
    p @tag_array

    # for i in @tag do
    #   @tag
    #   @tags.append
    # end


    # :
    # :
    
    # for tag in result[0]["tags"] do
    #   puts tag
    # end 


    @title2 = result[1]["title"]
    @name2= result[1]["user"]["name"]
    @created_at2 = result[1]["created_at"]
    @lgtm2 = result[1]["likes_count"]

    @title3 = result[2]["title"]
    @name3= result[2]["user"]["name"]
    @created_at3 = result[2]["created_at"]
    @lgtm3 = result[2]["likes_count"]
    # :
    # :
    
  end
end
