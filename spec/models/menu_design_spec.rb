require 'rails_helper'

RSpec.describe MenuDesign, type: :model do
  describe 'アソシエーションのテスト' do
    it 'メニューに属していること' do
      assoc = described_class.reflect_on_association(:menu)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'デザインに属していること' do
      assoc = described_class.reflect_on_association(:design)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
