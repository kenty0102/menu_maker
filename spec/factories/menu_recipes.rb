FactoryBot.define do
  factory :menu_recipe do
    association :menu
    association :recipe
  end
end
