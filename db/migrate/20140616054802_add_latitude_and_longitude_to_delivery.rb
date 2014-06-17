class AddLatitudeAndLongitudeToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :latitude, :float
    add_column :deliveries, :longitude, :float
  end
end
