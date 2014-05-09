class AddSecureOrderIdToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :secure_order_id, :string
  end
end
