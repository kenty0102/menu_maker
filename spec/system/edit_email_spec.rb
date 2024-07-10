require 'rails_helper'

RSpec.describe 'メールアドレスの変更', type: :system do
  let(:user) { create(:user) }

  before do
    login(user)
    click_link 'マイページ'
    click_link 'edit_email_link'
  end

  context "when 正しい情報が入力された場合" do
    it '正しい情報を入力した場合、変更に成功すること' do
      fill_in 'new_email', with: 'update@example.com'
      click_button '変更する'
      visit profile_path
      expect(user.reload.email).to eq 'update@example.com'
    end

    it '変更に成功した時にフラッシュメッセージが表示されること' do
      fill_in 'new_email', with: 'update@example.com'
      click_button '変更する'
      expect(page).to have_content 'メールアドレスを変更しました'
    end
  end

  context "when 不正な情報が入力された場合" do
    it 'メールアドレスの形式が不正な場合、エラーメッセージが表示される' do
      fill_in 'new_email', with: 'update.example.com'
      click_button '変更する'
      expect(page).to have_content 'メールアドレスの変更に失敗しました'
    end

    it 'すでに使用されているアドレスを入力した場合、エラーメッセージが表示される' do
      create(:user, email: 'existing@example.com')
      fill_in 'new_email', with: 'existing@example.com'
      click_button '変更する'
      expect(page).to have_content 'メールアドレスの変更に失敗しました'
    end
  end
end
