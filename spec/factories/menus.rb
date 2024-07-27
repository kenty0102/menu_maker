FactoryBot.define do
  factory :menu do
    association :user
    title { "MyString" }

    transient do
      recipes_count { 1 } # デフォルトで1つのレシピを関連付け
    end

    after(:create) do |menu, evaluator|
      create_list(:recipe, evaluator.recipes_count).each do |recipe|
        create(:menu_recipe, menu:, recipe:)
      end

      design = create(:design)
      create(:menu_design, menu:, design:)
    end
  end
end
