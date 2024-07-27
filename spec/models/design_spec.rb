require 'rails_helper'

RSpec.describe Design, type: :model do
  describe 'バリデーションのテスト' do
    it '名前が存在すること' do
      design = build(:design, name: nil)
      expect(design).not_to be_valid
    end

    it 'レイアウトが存在すること' do
      design = build(:design, layout: nil)
      expect(design).not_to be_valid
    end
  end

  describe 'アソシエーションのテスト' do
    it 'メニューとデザインの関連付けがあること' do
      assoc = described_class.reflect_on_association(:menus)
      expect(assoc.macro).to eq :has_many
    end
  end
end
