class UpdateFieldsForDeliveriesAndDeliveryItems < ActiveRecord::Migration
  def up
  	# For deliveries
    add_column :deliveries, :customer_phone_number, :string
  	change_column :deliveries, :order_grand_total, :decimal

    # For delivery_items
    add_column :delivery_items, :out_of_stok_quantity, :integer
    add_column :delivery_items, :scaned_quantity, :integer
  end

  def down
    remove_column :deliveries, :customer_phone_number
  	change_column :deliveries, :order_grand_total, :integer
    remove_column :delivery_items, :out_of_stok_quantity
    remove_column :delivery_items, :scaned_quantity
  end
end
