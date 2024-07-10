require 'rails_helper'

RSpec.describe 'パスワードの変更', type: :system do
  let(:user) { create(:user) }

  before do
    login(user)
    click_link 'マイページ'
    click_link 'パスワード変更'
  end

  context "when 正しい情報が入力された場合" do
    it '変更に成功した時にフラッシュメッセージが表示されること' do
      fill_in 'user_current_password', with: 'password'
      fill_in 'user_password', with: 'newpassword'
      fill_in 'user_password_confirmation', with: 'newpassword'
      click_button '変更する'
      expect(page).to have_content 'パスワードを変更しました'
    end

    it '変更後、新しいパスワードでログインできること' do
      new_password_confirmation
      fill_in 'email', with: user.email
      fill_in 'password', with: 'newpassword'
      click_button 'ログイン'
      expect(page).to have_link('ログアウト')
    end
  end

  context "when 不正な情報が入力された場合" do
    it '現在のパスワードが一致しない時、エラーメッセージが表示される' do
      fill_in 'user_current_password', with: 'different_password'
      fill_in 'user_password', with: 'newpassword'
      fill_in 'user_password_confirmation', with: 'newpassword'
      click_button '変更する'
      expect(page).to have_content 'パスワードの変更に失敗しました'
    end

    it '確認用のパスワードが一致しない時、エラーメッセージが表示される' do
      fill_in 'user_current_password', with: 'password'
      fill_in 'user_password', with: 'newpassword'
      fill_in 'user_password_confirmation', with: 'different_password'
      click_button '変更する'
      expect(page).to have_content 'パスワードの変更に失敗しました'
    end

    it '新しいパスワードが4文字未満の時、エラーメッセージが表示される' do
      fill_in 'user_current_password', with: 'password'
      fill_in 'user_password', with: 'abc'
      fill_in 'user_password_confirmation', with: 'abc'
      click_button '変更する'
      expect(page).to have_content 'パスワードの変更に失敗しました'
    end
  end
end
