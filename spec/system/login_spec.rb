require 'rails_helper'

RSpec.describe 'ログイン', type: :system do
  let(:user) { create(:user) }

  it 'ログインページに正しいタイトルが表示されている' do
    visit login_path
    expect(page).to have_title('ログイン | Menu Maker')
  end

  context 'when 正しい情報が入力された場合' do
    it 'ログインできる' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'password'
      click_button 'ログイン'
      expect(page).to have_link('ログアウト')
    end

    it 'ログイン成功時にフラッシュメッセージが表示される' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'password'
      click_button 'ログイン'
      expect(page).to have_content('ログインしました')
    end

    it 'ログイン後トップページへ遷移する' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'password'
      click_button 'ログイン'
      expect(page).to have_current_path(root_path)
    end
  end

  context 'when 入力情報が誤っている場合' do
    context 'when メールアドレスに誤りがある場合' do
      it 'ログインできないこと' do
        visit login_path
        fill_in 'email', with: 'example.com'
        fill_in 'password', with: 'password'
        click_button 'ログイン'
        expect(page).to have_button('ログイン')
      end
    end

    context 'when パスワードに誤りがある場合' do
      it 'ログインできないこと' do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: 'wrongpassword'
        click_button 'ログイン'
        expect(page).to have_button('ログイン')
      end
    end

    it 'ログイン失敗時にフラッシュメッセージが表示される' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'wrongpassword'
      click_button 'ログイン'
      expect(page).to have_content('ログインに失敗しました')
    end

    it 'ログイン失敗時は画面遷移しない' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'wrongpassword'
      click_button 'ログイン'
      expect(page).to have_current_path(login_path)
    end
  end
end
