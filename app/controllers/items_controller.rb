class ItemsController < ApplicationController
  def index
    # つけないと動かない　なぜ
    require 'net/http'
    # require 'uri'

    # params = URI.encode_www_form({created: >2022-1-31})
    # 日付を仮定
    today = Date.today
    params = (today - 7).strftime
    # params = "2022-1-31"
    # uri = URI.parse("https://qiita.com/api/v2/items?page=1&per_page=3&query=created:>#{params}")
    # response = Net::HTTP.get_response(uri)
    # result = JSON.parse(response.body)
    # p result


    result = []
    for i in 1..3 do
      uri = URI.parse("https://qiita.com/api/v2/items?page=#{i}&per_page=2&query=created:>#{params}")
      response = Net::HTTP.get_response(uri)
      result << JSON.parse(response.body)
    end
    p result.size

    # ページ数＝配列＝size

    # resultは配列　itemがたくさん入っている　
    # 配列がなくなるまで繰り返し表示させる必要がある
    # itemにはtitle,name,created_at,lgtm,tagsのセットが1つ入っている
    @test = result
    # puts @test

    @items = []
    # binding.irb
    # for i in 0..@test.size do
    # end

    # for f in 0..2 do
    # これで動く？
    # end
    for f in 0..(@test[0].size-1) do
      for val in @test do
        @title = val[f]["title"]
        @lgtm = val[f]["likes_count"]
        @created_at = val[f]["created_at"]
        @name = val[f]["user"]["name"]
        @tag = val[f]["tags"]
          @tag_names= []
          # each文で回したいので配列で取得する
          @tag.each { |t|
            @tag_name = t["name"]
            @tag_names.append(@tag_name)
          }
        @items.append(@title,@lgtm,@created_at,@name,@tag_names)
          # p @tag_names

        # # no implicit でエラーが出たので修正必要 数値がくるべきところに文字がきた
        # @title = val[f]["title"]
        # @lgtm = "#{val[f]["likes_count"]}"
        # @created_at =  "#{val[f]["created_at"]}"
        # @name =  "#{val[f]["user"]["name"]}"
        # @tag = val[f]["tags"]
        #   # p @tag
        #   @tag_names= []
        #   # each文で回したいので配列で取得する
        #   @tag.each { |t|
        #     @tag_name = t["name"]
        #     @tag_names.append(@tag_name)
        #   }
        #   # p @tag_names
        # # p "tagは" + @tag
        # @items.append(@title,@lgtm,@created_at,@name,@tag_names)
      end
    end
      # p "配列の中身は" + @items.to_s
      @all_items = @items.each_slice(5).to_a
      p @all_items

    # # 1個目のみ
    # @title = result[0]["title"]
    # @name= result[0]["user"]["name"]
    # @created_at = result[0]["created_at"]
    # @lgtm = result[0]["likes_count"]
    # 1個目のみ
    # @tags = result[0]["tags"]
    #   p @tags
    # @tag_names= []
    # # each文で回したいので配列で取得する
    # @tags.each { |tag|
    #   @tag_name = tag["name"]
    #   @tag_names.append(@tag_name)
    # }
    # p @tag_names
  end
end
