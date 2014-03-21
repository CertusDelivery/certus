FactoryGirl.define do
  factory :delivery do
    picked_status { Delivery::PICKED_STATUS[:unpicked] }
    picked_sku_count 0
    picked_piece_count 0
    total_shipping_weight { Faker.numerify('##.#') }
    total_payment_adjustment 0
    lat { Faker::Geolocation.lat }
    lng { Faker::Geolocation.lng }
    picked_at { Time.now }
    order_id { Faker.numerify('#########') }
    order_piece_count { 2 }
    order_total_price { Faker.numerify('###.##') }
    order_total_tax { Faker.numerify('#.##') }
    order_total_adjustments 0
    order_non_apportionable_adjustments 0
    order_grand_total { order_total_price }
    order_status 'IN_FULFILLMENT'
    payment_id { Faker.numerify('#####') }
    payment_card_token { Faker::Lorem.characters(40) }
    payment_amount { order_total_price }
    placed_at { Time.now - 1.hour }
    desired_delivery_window { Time.now + 2.hour }
    customer_name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    shipping_address { "#{Faker::AddressUS.building_number} #{Faker::AddressUS.street_address(true)} #{Faker::AddressUS.city} #{Faker::AddressUS.state} #{Faker::AddressUS.zip_code}" }
    customer_email { Faker::Internet.email }
    customer_phone_number { Faker.numerify('#########') }


    trait :unpicked do
      picked_status { Delivery::PICKED_STATUS[:unpicked] }
    end

    trait :picking do
      picked_status { Delivery::PICKED_STATUS[:picking] }
    end

    trait :picked do
      picked_status { Delivery::PICKED_STATUS[:picked] }
      picked_piece_count 2
    end

    trait :store_staging do
      picked_status { Delivery::PICKED_STATUS[:store_staging] }
      picked_piece_count 2
    end

  end
end