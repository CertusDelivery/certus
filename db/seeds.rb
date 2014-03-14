# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
deliveries = []
deliveries << Delivery.create(bin_geocode: 1, order_status: 'PICKING')
deliveries << Delivery.create(bin_geocode: 2, order_status: 'PICKING')
deliveries << Delivery.create(bin_geocode: 3, order_status: 'UNPICKED')

deliveries.each do |delivery|
    delivery.delivery_items << [DeliveryItem.create(picked_status: '1/0/0/0', product_name: 'Special K Cereal - Strawberry',
                                    shipping_weight: '18.0',shipping_weight_unit: 'liter', location: '12N-45-4', picked_quantity: 1, picker_bin_number: '12400', store_sku: '6143854'),
                                DeliveryItem.create(picked_status: '2/0/0/0', product_name: 'Purell Hand Sanitizer',
                                    shipping_weight: '12.6',shipping_weight_unit: 'oz', location: '7N-30-3', picked_quantity: 3, picker_bin_number: '12345', store_sku: '073852400908'),
                              DeliveryItem.create(picked_status: '1/1/0/0', product_name: 'Diet Coke',
                                    shipping_weight: '12.6', shipping_weight_unit: 'oz', location: '7N-35-3', picked_quantity: 3, picker_bin_number: '12345', store_sku: '073852400908')]
end