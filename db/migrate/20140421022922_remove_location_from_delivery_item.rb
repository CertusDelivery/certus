class RemoveLocationFromDeliveryItem < ActiveRecord::Migration
  def change
    remove_column :delivery_items, :location_id
  end
end
