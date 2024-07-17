require 'faker'

FactoryBot.define do
  factory :ingredient do
    association :recipe
    name { Faker::Food.ingredient }
    quantity { rand(1..10).to_s }
    unit { "g" }
  end
end
