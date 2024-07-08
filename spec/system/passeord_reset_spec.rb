require 'rails_helper'

RSpec.describe 'パスワードリセット', type: :system do
  let(:user) { create :user }

  describe 'パスワード再設定メール送信' do
    before do
      visit new_password_reset_path
      fill_in 'email', with: user.email
      click_button '申請する'
    end

    it 'メール送信後のメッセージを確認' do
      expect(page).to have_content('パスワード再設定メールを送信しました')
    end
  end
end
