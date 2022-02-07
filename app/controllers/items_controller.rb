class ItemsController < ApplicationController


  def index
    # つけないと動かない　なぜ
    require 'net/http'
    # require 'uri'

    # params = URI.encode_www_form({created: >2022-1-31})
    # 日付を仮定
    params = "2022-1-31"
    uri = URI.parse("https://qiita.com/api/v2/items?page=1&per_page=3&query=created:>#{params}")
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)


    # resultは配列　itemがたくさん入っている　
    # 配列がなくなるまで繰り返し表示させる必要がある
    # itemにはtitle,name,created_at,lgtm,tagsのセットが1つ入っている
    @test = result


    # 1個目のみ
    @title = result[0]["title"]
    @name= result[0]["user"]["name"]
    @created_at = result[0]["created_at"]
    @lgtm = result[0]["likes_count"]
    # 1個目のみ
    @tags = result[0]["tags"]

    @tag_names= []
    # each文で回したいので配列で取得する
    @tags.each { |tag|
      @tag_name = tag["name"]
      @tag_names.append(@tag_name)
    }
    # p @tag_array

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
