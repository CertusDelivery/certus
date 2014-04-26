class AddFieldsToDeliveryItems < ActiveRecord::Migration
  def change
    add_column :delivery_items, :store_sku, :integer
    add_column :delivery_items, :location, :text
    add_column :delivery_items, :picked_quantity, :integer
    add_column :delivery_items, :picked_status, :string
    add_column :delivery_items, :substitute_sku, :integer
    add_column :delivery_items, :picked_datetime, :datetime
    add_column :delivery_items, :shipping_weight, :decimal
    add_column :delivery_items, :picker_bin_number, :string
    add_column :delivery_items, :payment_adjustment, :string
  end
end
