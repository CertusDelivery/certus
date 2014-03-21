def create_delivery_params
    post_params = {:delivery=> { customer_name: Faker::Name.name,
                                  shipping_address: Faker::AddressUS.street_address(true),
                                  customer_email: Faker::Internet.email,
                                  order_id: Faker.numerify('#########'),
                                  order_piece_count:3,
                                  payment_id:Faker.numerify('#####'),
                                  payment_card_token:Faker::Lorem.characters(40),
                                  payment_amount: 1000,
                                  order_status: 'PLACED',
                                  picked_status: 'UNPICKED',
                                  order_grand_total: 200,
                                  payment_amount: 200,
                                  order_sku_count: 1,
                                  order_total_price:200,
                                  placed_at: Time.now - 1.hour,
                                 delivery_items_attributes: [
                                     {picked_status: '1/0/0/0', product_name: 'Special K Cereal - Strawberry', quantity: 1,
                                      shipping_weight: '18.0',shipping_weight_unit: 'liter', location: '12N-45-4', picked_quantity: 0,
                                      picker_bin_number: '12400', store_sku: '6143854', client_sku: '6143854', price: 200}
                                 ]
                }}
end

def create_delivery(picked_status = :unpicked)
  item_count = rand(10) + 1
  delivery = FactoryGirl.build :delivery, picked_status, order_sku_count: item_count
  total_price = 0
  item_count.times do
    delivery_item = FactoryGirl.build(:delivery_item)
    delivery.delivery_items << delivery_item
    total_price += delivery_item.price
  end
  delivery.payment_amount = delivery.order_grand_total = delivery.order_total_price = total_price
  delivery.save!
  delivery
end