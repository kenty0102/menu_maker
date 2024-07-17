require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe "バリデーションのテスト" do
    it 'タイトルが存在すること' do
      recipe = build(:recipe, title: nil)
      expect(recipe).not_to be_valid
    end

    it 'source_urlが正しい形式であること' do
      recipe = build(:recipe, source_url: 'invalid_url')
      expect(recipe).not_to be_valid
    end
  end
end
