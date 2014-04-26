class ModifyLocationColumnInProductAndDeliveryItem < ActiveRecord::Migration
  def change
    remove_column :delivery_items, :location
    add_column :delivery_items, :location_id, :integer

    remove_column :products, :location
    add_column :products, :location_id, :integer
  end
end
