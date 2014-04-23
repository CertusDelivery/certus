FactoryGirl.define do
  factory :product do
    name { Faker::Product.product_name }
    store_sku { Faker.numerify('###############') }
    location { FactoryGirl.create(:location) }
    shipping_weight { Faker.numerify('##.##').to_f }
    shipping_weight_unit { %w{oz kg g liter}.sample }
    adjustment { Faker.numerify('#.#5') }
    price { Faker.numerify('##.#1') }
    taxable true
    tax_rate 0.0635
    stock_stauts 'IN_STOCK'

    trait :food do
      taxable false
      tax_rate 0
    end
  end
end
