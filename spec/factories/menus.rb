FactoryBot.define do
  factory :menu do
    association :user
    title { "MyString" }

    transient do
      recipes_count { 1 } # デフォルトで1つのレシピを関連付け
      design_count { 1 } # デフォルトで1つのデザインを関連づけ
    end

    after(:create) do |menu, evaluator|
      create_list(:recipe, evaluator.recipes_count).each do |recipe|
        create(:menu_recipe, menu:, recipe:)
      end

      create_list(:design, evaluator.design_count).each do |design|
        menu.update(design:)
      end
    end
  end
end
