class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: false do |t|
      t.string :qiita_id
      t.string :name

      t.timestamps
    end
  end
end
