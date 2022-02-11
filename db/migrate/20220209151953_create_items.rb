class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :title
      t.string :url
      t.integer :lgtm
      t.string :user_name
      t.datetime :posted_at
      t.string :tag
      t.string :qiita_id

      t.timestamps
    end
  end
end
