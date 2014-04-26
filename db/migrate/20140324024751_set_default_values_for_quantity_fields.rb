class SetDefaultValuesForQuantityFields < ActiveRecord::Migration
  def up
    change_column :delivery_items, :picked_quantity, :integer, default: 0
    change_column :delivery_items, :out_of_stock_quantity, :integer, default: 0
    change_column :delivery_items, :scanned_quantity, :integer, default: 0
  end

  def down
    change_column :delivery_items, :picked_quantity, :integer, default: nil
    change_column :delivery_items, :out_of_stock_quantity, :integer, default: nil
    change_column :delivery_items, :scanned_quantity, :integer, default: nil
  end
end
