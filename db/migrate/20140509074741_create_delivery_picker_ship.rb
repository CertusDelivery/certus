class CreateDeliveryPickerShip < ActiveRecord::Migration
  def change
    create_table :delivery_picker_ships do |t|
      t.integer :delivery_id
      t.integer :picker_id
    end
  end
end
