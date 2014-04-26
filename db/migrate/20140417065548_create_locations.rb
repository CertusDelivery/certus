class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :info

      t.string :aisle
      t.string :direction
      t.integer :distance
      t.integer :shelf
    end
    add_index :locations, :info, unique: true
  end
end
