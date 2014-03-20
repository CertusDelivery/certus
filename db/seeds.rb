# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Delivery.delete_all
deliveries = []

def create_delivery(item)
	delivery = Delivery.new( customer_name: Faker::Name.name,
								 shipping_address: Faker::Address.street_address(true),
								 customer_email: 'test@test.com',
								 order_id: item,
	               order_piece_count:3,
								 payment_id:rand(9999),
								 payment_card_token: rand(999999999).to_s,
	               payment_amount: 1000,
								 order_status: 'IN_FULFILLMENT',
								 picked_status: 'UNPICKED',
								 order_grand_total: 500,
								 payment_amount: 500,
								 order_sku_count: 3,
								 order_total_price: 500,
								 placed_at: Date.today
	               )

	delivery.delivery_items = [
			DeliveryItem.create(picked_status: '1/0/0/0', product_name: 'Special K Cereal - Strawberry', quantity: 1,
													shipping_weight: '18.0',shipping_weight_unit: 'liter', location: '12N-45-4', picked_quantity: 0,
													picker_bin_number: '12400', store_sku: '6143854', client_sku: '6143854', price: 200),
			DeliveryItem.create(picked_status: '2/0/0/0', product_name: 'Purell Hand Sanitizer', quantity: 2,
													shipping_weight: '12.6',shipping_weight_unit: 'oz', location: '7N-30-3', picked_quantity: 1,
													picker_bin_number: '12345', store_sku: '073852400908', client_sku: '073852400908', price: 200),
			DeliveryItem.create(picked_status: '1/1/0/0', product_name: 'Diet Coke', shipping_weight: '12.6', quantity: 1,
													shipping_weight_unit: 'oz', location: '7N-35-3', picked_quantity: 1, picker_bin_number: '12345',
													store_sku: '073852400908', client_sku: '073852400908', price: 100)]
	delivery
	delivery.save!

end

100.times { |item|
	puts "Create delivery #{item+1}"
	create_delivery item
}

