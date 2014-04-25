class AddDeliveryOptionToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :delivery_option, :string
    add_column :deliveries, :secure_salt, :string
  end
end
