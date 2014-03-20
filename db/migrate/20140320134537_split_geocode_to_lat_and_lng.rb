class SplitGeocodeToLatAndLng < ActiveRecord::Migration
  def change
  	remove_column :deliveries, :bin_geocode
  	add_column :deliveries, :lat, :string
  	add_column :deliveries, :lng, :string
  end
end
