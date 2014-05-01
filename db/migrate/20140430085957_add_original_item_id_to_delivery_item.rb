class AddOriginalItemIdToDeliveryItem < ActiveRecord::Migration
  def change
    add_column :delivery_items, :original_item_id, :integer
  end
end
