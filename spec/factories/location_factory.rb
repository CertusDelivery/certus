FactoryGirl.define do
  factory :location do
    aisle { (1..999).to_a.sample.to_s } 
    direction { %w{N S E W}.sample }
    distance { (1..99).to_a.sample }
    shelf { (1..9).to_a.sample }
  end
end
