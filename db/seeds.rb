require 'factory_girl'
require 'ffaker'
Dir["#{Rails.root}/spec/factories/**/*.rb"].each { |f| require f }

Delivery.delete_all
DeliveryItem.delete_all
deliveries = []

def create_delivery(picked_status = :unpicked)
  item_count = rand(1..3)
  delivery = FactoryGirl.build :delivery, picked_status, order_sku_count: item_count
  total_price = 0
  item_count.times do
    delivery_item = FactoryGirl.build(:delivery_item)
    delivery.delivery_items << delivery_item
    total_price += delivery_item.total_price
  end
  delivery.payment_amount = delivery.order_grand_total = delivery.order_total_price = total_price
  delivery.save
end

100.times do
  create_delivery
end
puts "Created 100 unpicked deliveries."

2.times do
  create_delivery :picking
end
puts "Created 2 picking deliveries."

DeliveryItem.all.each do |item|
  FactoryGirl.create(:product, store_sku: item.store_sku)
end
puts "Created #{DeliveryItem.all.size} products for DeliveryItem."

100.times do
  FactoryGirl.create(:product)
end
puts "Created 100 non-food products."

100.times do
  FactoryGirl.create(:product, :food)
end
puts "Created 100 food products."
