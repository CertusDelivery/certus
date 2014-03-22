FactoryGirl.define do
  factory :delivery_item do
    picked_quantity 0
    store_sku { Faker.numerify('###############') }
    client_sku { store_sku }
    location { "#{Faker.numerify('##')}#{%w{N S E W}.sample}-#{Faker.numerify('##')}-#{Faker.numerify('#')}"}
    shipping_weight { Faker.numerify('##.##').to_f }
    picker_bin_number { Faker.numerify('#######') }
    payment_adjustment 0
    product_name { Faker::Product.product_name }
    quantity { rand(1..10) }
    price { Faker.numerify('##.##') }
    tax { Faker.numerify('#.##') }
    shipping_weight_unit { %w{oz kg g liter}.sample }
    out_of_stock_quantity 0
    scanned_quantity 0
  end
end
