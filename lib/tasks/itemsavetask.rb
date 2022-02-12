require "#{Rails.root}/app/models/item"

class Tasks::Itemsavetask
  def self.save
    # p "こんにちは"
    # controller = ItemsController.new
    # controller.create
    Item.create(title: "テストda-")
  end
end