class ItemsController < ApplicationController
  before_action :get_data


  def index
    # 10件ずつ扱う
    @items = Item.all.each_slice(10)
  end

  def create
    # バッチ　リロードしたらすぐ保存
    # all_itemsで上位10件を取得
    @all_items.first(10).each do |a, b, c, d, e, f, g|
      # p g
      Item.create(title: a, url: b, lgtm: c, user_name: e, posted_at: d, tag: f, qiita_id: g)
      # すでにユーザーが存在していたらItemのみを保存する
      unless User.exists?(qiita_id: g)
        User.create(qiita_id: g, name: e)
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def show
    @first = params[:id].to_i
    # 10件を取得
    @items = Item.where(id: @first..(@first+9))
    @items_first = Item.find(@first)
  end

  private
    def get_data
      require 'net/http'
      require 'open-uri'

      today = Date.today
      # 1週間前の日付を取得
      params_date = (today - 7).strftime

      # アクセストークン環境変数化
      access_token = ENV['access_token']
      headers = {'Authorization' => "Bearer #{access_token}"}

      # pageを回して配列でデータを取得
      result = []
      i = 1
      while i <= 2 do
        uri = URI.parse("https://qiita.com/api/v2/items?page=#{i}&per_page=10&query=created:>#{params_date}")
        res = URI.open(uri, headers)
        result << JSON.parse(res.read)
        i += 1
      end
      # p result

      # items[]に全てのデータを格納
      items = []
      # binding.irb
      for f in 0..(result[0].size-1) do
        for val in result do
          if val[f]
            title = val[f]["title"]
            url = val[f]["url"]
            lgtm = val[f]["likes_count"]
            created_at = val[f]["created_at"]
            name = val[f]["user"]["name"]
            tag = val[f]["tags"]
            id = val[f]["user"]["id"]
              tag_names= []
              # each文で回して取得する
              tag.each { |t|
                tag_name = t["name"]
                tag_names.append(tag_name)
              }
            items.append(title,url,lgtm,created_at,name,tag_names,id)
          end
        end
      end
        # itemsから1セット（7つのデータ）ずつ切り分けて格納
        set_items = items.each_slice(7).to_a
        # 要素3つ目(lgtm数で並び替え)
        set_items.sort_by! { |a| a[2] }
        # lgtm数の多い順に表示
        @liked_all_items = set_items.reverse

        # ページネーション
        @all_items = Kaminari.paginate_array(@liked_all_items).page(params[:page]).per(10)
    end

end
