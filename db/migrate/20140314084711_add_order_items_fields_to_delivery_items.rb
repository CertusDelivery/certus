class AddOrderItemsFieldsToDeliveryItems < ActiveRecord::Migration
  def change
    add_column :delivery_items, :delivery_id, :integer
    add_column :delivery_items, :client_slu, :string
    add_column :delivery_items, :quantity, :decimal
    add_column :delivery_items, :price, :decimal
    add_column :delivery_items, :tax, :decimal
    add_column :delivery_items, :other_adjustments, :text
    add_column :delivery_items, :order_item_amount, :decimal
    add_column :delivery_items, :order_item_options_flags, :string
  end
end
