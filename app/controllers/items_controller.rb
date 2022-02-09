class ItemsController < ApplicationController
  def index
    require 'net/http'
    require 'open-uri'

    today = Date.today
    # 1週間前の日付を取得
    params2 = (today - 7).strftime

    # アクセストークン
    access_token = ENV['access_token']
    headers = {'Authorization' => "Bearer #{access_token}"}

    # pageを回して配列で取得
    result = []
    # # 1~3ページ目まで回す
    i = 1
    while i <= 100 do
    # for i in 1..100 do
      uri = URI.parse("https://qiita.com/api/v2/items?page=#{i}&per_page=100&query=created:>#{params2}")
      res = URI.open(uri, headers)
      result << JSON.parse(res.read)
      i += 1
    end

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
      # @all_itemss = @items.each_slice(6).to_a.sort[2]
      # p @all_items
      @all_items.sort_by! { |a| a[2] }
      @liked_all_items = @all_items.reverse
      # @liked_all_items = Kaminari.paginate_array(@liked_all_items).page(1).per(2)

      # order("liked_at": :DESC)
      # @all_itemsss = @items.each_slice(6)
      # p @all_itemsss
      # binding.irb
      # p @liked_all_items[0]

      @array2 = []
      @liked_all_items.each do |f|
        @array2.push({
          title: f[0],
          url: f[1],
          lgtm: f[2],
          created_at: f[3],
          name: f[4],
          tag: f[5]
        })
      end
      # @array3 = @array2.each_slice(6).to_a
      # p @array2.each_slice(6).to_a

      # @allitemss = @array2.page(params[:page]).per(1)
      # for N in 0..3 do

      # p @items.each_slice(6)
  # binding.irb
        @all_itemss = Kaminari.paginate_array(@liked_all_items).page(params[:page]).per(20)
        # p @all_itemss
      # end

      # p @items

  end
end
