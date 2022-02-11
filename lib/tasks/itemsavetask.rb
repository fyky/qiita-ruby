require "#{Rails.root}/app/models/item"

class Tasks::Itemsavetask
  def self.save
    p "こんにちは"
    # Item.create(title: "テスト")
  end
end