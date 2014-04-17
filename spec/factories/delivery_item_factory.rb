FactoryGirl.define do
  factory :delivery_item do
    picked_status 'UNPICKED'
    picked_quantity 0
    store_sku { Faker.numerify('###############') }
    location { FactoryGirl.create(:location) }
    client_sku { store_sku }
    shipping_weight { Faker.numerify('##.##').to_f }
    picker_bin_number { Faker.numerify('#######') }
    payment_adjustment 0
    product_name { Faker::Product.product_name }
    quantity { rand(1..10) }
    price { Faker.numerify('##.#1') }
    tax { Faker.numerify('#.##') }
    shipping_weight_unit { %w{oz kg g liter}.sample }
    out_of_stock_quantity 0
    scanned_quantity 0
    other_adjustments 0
  end
end
