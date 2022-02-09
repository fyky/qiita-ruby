class ItemsController < ApplicationController
  def index
    require 'net/http'
    require 'open-uri'

    today = Date.today
    # 1週間前の日付を取得
    params = (today - 7).strftime

    # アクセストークン
    access_token = ENV['access_token']
    headers = {'Authorization' => "Bearer #{access_token}"}

    # pageを回して配列で取得
    result = []
    # # 1~3ページ目まで回す
    i = 1
    while i <= 2 do
    # for i in 1..100 do
      uri = URI.parse("https://qiita.com/api/v2/items?page=#{i}&per_page=2&query=created:>#{params}")
      res = URI.open(uri, headers)
      result << JSON.parse(res.read)
      i += 1
      # response = Net::HTTP.get_response(uri, headers)
      # result << JSON.parse(response.body)
      # i += 1
      # result << JSON.parse(uri.read)
    end

    # binding.irb
    # p result.size
    # result = [[{"title"=>"タイトル"},{"lgtm"=>"10"},{"user"=>{"name"=>"uu"}},{"created_at"=>"x"},{"tag"=>"y"}],
    # [{"title"=>"タイトル"},{"lgtm"=>"10"},{"user"=>{"name"=>"uu"}},{"created_at"=>"x"},{"tag"=>"y"}],
    # [{"title"=>"タイトル"},{"lgtm"=>"10"},{"user"=>{"name"=>"uu"}},{"created_at"=>"x"},{"tag"=>"y"}]]
    # p result[0]["user"]["name"]

    # ページ数＝配列＝size

    @items = []
    # binding.irb
    for f in 0..(result[0].size-1) do
      for val in result do
        if val[f]
          @title = val[f]["title"]
          @url = val[f]["url"]
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
          @items.append(@title,@url,@lgtm,@created_at,@name,@tag_names)
        end
          # p @tag_names
      end
    end
      @all_items = @items.each_slice(6).to_a
      # .page(params[:page]).per(3)
      p @all_items

  end
end
