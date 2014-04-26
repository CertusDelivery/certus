class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :name, null: false
      t.string  :store_sku, null: false
      t.string  :location
      t.decimal :shipping_weight
      t.string  :shipping_weight_unit
      t.decimal :adjustment
      t.decimal :price
      t.boolean :taxable
      t.decimal :tax_rate

      t.timestamps
    end
  end
end
