class UpdateColumnsOfDeliveryItems < ActiveRecord::Migration
  def up
    rename_column :delivery_items, :out_of_stok_quantity, :out_of_stock_quantity
    rename_column :delivery_items, :scaned_quantity, :scanned_quantity
    change_column :delivery_items, :quantity, :integer
  end

  def down
    rename_column :delivery_items, :out_of_stock_quantity, :out_of_stok_quantity
    rename_column :delivery_items, :scanned_quantity, :scaned_quantity
    change_column :delivery_items, :quantity, :decimal
  end
end
