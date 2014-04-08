class AddFieldsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :category_id, :integer
    add_column :products, :reg_price, :decimal
    add_column :products, :unit_price, :decimal
    add_column :products, :unit_price_unit, :string
    add_column :products, :sale_qty_min, :integer
    add_column :products, :sale_qty_limit, :integer
    add_column :products, :size, :text
    add_column :products, :brand, :string
    add_column :products, :image, :string
    add_column :products, :info_1, :text
    add_column :products, :info_2, :text
  end
end
