require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションのテスト" do
    let(:user) { build(:user) }

    context "when 正しい情報が入力された場合" do
      it "ユーザーが有効である" do
        expect(user).to be_valid
      end
    end

    context "when 不正な情報が入力された場合" do
      it "メールアドレスが一意でなければ無効である" do
        user1 = create(:user)
        user2 = build(:user)
        user2.email = user1.email
        expect(user2).not_to be_valid
      end

      it "パスワードが4文字未満の場合は無効である" do
        user.password = "abc"
        user.password_confirmation = "abc"
        expect(user).not_to be_valid
      end

      it "パスワードとパスワード確認が一致しない場合は無効である" do
        user.password_confirmation = "different"
        expect(user).not_to be_valid
      end
    end

    it "名前は必須項目である" do
      user.name = nil
      expect(user).not_to be_valid
    end

    it "メールアドレスは必須項目である" do
      user.email = nil
      expect(user).not_to be_valid
    end
  end
end
