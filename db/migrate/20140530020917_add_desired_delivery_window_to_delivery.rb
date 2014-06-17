class AddDesiredDeliveryWindowToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :desired_delivery_window_begin, :datetime
    add_column :deliveries, :desired_delivery_window_end, :datetime
  end
end
