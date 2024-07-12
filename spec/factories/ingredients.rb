FactoryBot.define do
  factory :ingredient do
    recipe { nil }
    name { "MyString" }
    quantity { "MyString" }
    unit { "MyString" }
  end
end
