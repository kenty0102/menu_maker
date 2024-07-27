require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'バリデーションのテスト' do
    let(:recipe) { create(:recipe) }
    let(:menu) { create(:menu, user:, recipe_ids: [recipe.id]) }

    it 'タイトルが存在すること' do
      menu = build(:menu, title: nil)
      expect(menu).not_to be_valid
    end

    it 'タイトルがユニークであること' do
      recipe = create(:recipe) # 必要なレシピを作成
      create(:menu, title: 'UniqueTitle', recipe_ids: [recipe.id]) # 同じタイトルでメニューを作成

      # 新しいメニューを作成し、レシピを追加
      new_menu = build(:menu, title: 'UniqueTitle', recipe_ids: [recipe.id])
      new_menu.save

      expect(new_menu).not_to be_valid
    end

    it '少なくとも1つのレシピが必要であること' do
      menu = build(:menu, recipe_ids: [])
      expect(menu).not_to be_valid
    end
  end

  describe 'アソシエーションのテスト' do
    it 'ユーザーに属していること' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'メニューとレシピの関連付けがあること' do
      assoc = described_class.reflect_on_association(:recipes)
      expect(assoc.macro).to eq :has_many
    end

    it 'メニューとデザインの関連付けがあること' do
      assoc = described_class.reflect_on_association(:designs)
      expect(assoc.macro).to eq :has_many
    end
  end
end
