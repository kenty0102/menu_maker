require 'rails_helper'

RSpec.describe Instruction, type: :model do
  describe "バリデーションのテスト" do
    it '手順番号が存在すること' do
      instruction = build(:instruction, step_number: nil)
      expect(instruction).not_to be_valid
    end

    it '手順番号が1以上であること' do
      instruction = build(:instruction, step_number: 0)
      expect(instruction).not_to be_valid
    end

    it '説明が存在すること' do
      instruction = build(:instruction, description: nil)
      expect(instruction).not_to be_valid
    end

    it '説明が500文字以下であること' do
      instruction = build(:instruction, description: 'a' * 501)
      expect(instruction).not_to be_valid
    end
  end
end
