require 'faker'

FactoryBot.define do
  factory :instruction do
    association :recipe
    step_number { 1 }
    description { Faker::Food.description }
  end
end
