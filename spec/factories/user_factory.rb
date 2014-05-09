FactoryGirl.define do
  factory :user do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Faker::Internet.email }
    login                 { Faker.numerify('######') } 
    password              "P4$$word"
    password_confirmation "P4$$word"
    role                  'picker'

    trait :admin do
      role { 'admin' }
    end

    trait :picker do
      role { 'picker' }
    end
  end
end
