class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|

      t.timestamps
    end
  end
end
