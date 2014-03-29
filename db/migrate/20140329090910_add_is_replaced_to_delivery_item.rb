class AddIsReplacedToDeliveryItem < ActiveRecord::Migration
  def change
    add_column :delivery_items, :is_replaced, :boolean, default: false
  end
end
