require 'factory_girl'
require 'ffaker'
Dir["#{Rails.root}/spec/factories/**/*.rb"].each { |f| require f }

Delivery.delete_all
DeliveryItem.delete_all
deliveries = []

def create_delivery(picked_status = :unpicked)
  item_count = rand(1..10)
  delivery = FactoryGirl.build :delivery, picked_status, order_sku_count: item_count
  total_price = 0
  item_count.times do
    delivery_item = FactoryGirl.build(:delivery_item)
    delivery.delivery_items << delivery_item
    total_price += delivery_item.price
  end
  delivery.payment_amount = delivery.order_grand_total = delivery.order_total_price = total_price
  delivery.save!
end

100.times { |item|
  puts "Create unpicked delivery #{item+1}"
  create_delivery
}

2.times { |item|
  puts "Create picking delivery #{item+1}"
  create_delivery :picking
}


