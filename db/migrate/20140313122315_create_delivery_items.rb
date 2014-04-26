class CreateDeliveryItems < ActiveRecord::Migration
  def change
    create_table :delivery_items do |t|

      t.timestamps
    end
  end
end
