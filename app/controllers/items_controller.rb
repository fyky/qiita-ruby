class ItemsController < ApplicationController
  before_action :get_data
  
  def index
  end

  def create

  end

  private
    def get_data
      require 'net/http'
      require 'open-uri'
      # @name2 = Kaminari.paginate_array(@liked_all_items).page(params[:page]).per(10)
      # @name2 = [["【Kuberntes】WorkerNodeが乗っ取られてもNodeRestrictionをONにしてれば大丈夫", "https://qiita.com/mti_tw/items/31db93798d776f384c9e", 0, "2022-02-10T14:00:43+09:00", "", ["kubernetes"], "mti_tw"], ["Autonomous Database と APEX で BIデータ更新アプリ をクイックに作成する", "https://qiita.com/yama6/items/d6b250f87ac865cde32a", 0, "2022-02-10T14:05:05+09:00", "", ["Apex", "oci", "AutonomousDatabase"], "yama6"]]
      today = Date.today
      # 1週間前の日付を取得
      params_date = (today - 7).strftime

      # アクセストークン環境変数化
      access_token = ENV['access_token']
      headers = {'Authorization' => "Bearer #{access_token}"}

      # pageを回して配列でデータを取得
      result = []
      i = 1
      while i <= 1 do
        uri = URI.parse("https://qiita.com/api/v2/items?page=#{i}&per_page=2&query=created:>#{params_date}")
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
            # items.create(:title => title)
            # (title: title,url: url,lgtm: lgtm,user_name: name, posted_at: created_at, tag: tag_names, qiita_id: id)
          end
        end
      end
        # itemsから1セット（6つのデータ）ずつ切り分けて格納
        set_items = items.each_slice(7).to_a
        # 要素3つ目(lgtm数で並び替え)
        set_items.sort_by! { |a| a[2] }
        # lgtm数の多い順に表示
        @liked_all_items = set_items.reverse

        # ページネーション
        @all_items = Kaminari.paginate_array(@liked_all_items).page(params[:page]).per(10)
    end

end
