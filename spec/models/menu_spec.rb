require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }
    let!(:existing_menu) { create(:menu, user:, title: 'UniqueTitle', recipe_ids: [recipe.id]) }

    it 'タイトルがユニークであること' do
      new_menu = build(:menu, title: existing_menu.title, user:, recipe_ids: [recipe.id])
      expect(new_menu).not_to be_valid
    end

    it '少なくとも1つのレシピが必要であること' do
      menu = build(:menu, user:, recipe_ids: [])
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
