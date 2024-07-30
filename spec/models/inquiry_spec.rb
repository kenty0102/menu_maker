require 'rails_helper'

RSpec.describe Inquiry, type: :model do
  describe "バリデーションのテスト" do
    it '有効な属性の場合は有効であること' do
      inquiry = build(:inquiry)
      expect(inquiry).to be_valid
    end

    it '名前がない場合は無効であること' do
      inquiry = build(:inquiry, name: nil)
      expect(inquiry).not_to be_valid
    end

    it 'メールアドレスがない場合は無効であること' do
      inquiry = build(:inquiry, email: nil)
      expect(inquiry).not_to be_valid
    end

    it '不正な形式のメールアドレスの場合は無効であること' do
      inquiry = build(:inquiry, email: 'invalid_email')
      expect(inquiry).not_to be_valid
    end

    it 'メッセージがない場合は無効であること' do
      inquiry = build(:inquiry, message: nil)
      expect(inquiry).not_to be_valid
    end

    it 'メッセージが500文字を超える場合は無効であること' do
      inquiry = build(:inquiry, message: 'a' * 501)
      expect(inquiry).not_to be_valid
    end
  end
end
