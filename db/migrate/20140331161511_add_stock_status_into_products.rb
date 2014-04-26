class AddStockStatusIntoProducts < ActiveRecord::Migration
  def change
    add_column :products, :stock_status, :string, default: 'IN_STOCK'
  end
end
