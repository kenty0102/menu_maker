require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe "バリデーションのテスト" do
    it '名前が存在すること' do
      ingredient = build(:ingredient, name: nil)
      expect(ingredient).not_to be_valid
    end

    it '単位が存在すること' do
      ingredient = build(:ingredient, unit: nil)
      expect(ingredient).not_to be_valid
    end

    it '量が数値であること' do
      ingredient = build(:ingredient, quantity: 'abc')
      expect(ingredient).not_to be_valid
    end
  end
end
