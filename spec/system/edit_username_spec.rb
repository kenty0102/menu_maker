require 'rails_helper'

RSpec.describe 'ユーザー名の変更', type: :system do
  let(:user) { create(:user) }

  before do
    login(user)
    click_link 'マイページ'
    click_link 'edit_username_link'
  end

  it '正しい情報を入力した場合、変更に成功すること' do
    fill_in 'new_name', with: 'NewUsername'
    click_button '変更'
    visit profile_path
    expect(user.reload.name).to eq 'NewUsername'
  end

  it '変更に成功した時にフラッシュメッセージが表示されること' do
    fill_in 'new_name', with: 'NewUsername'
    click_button '変更'
    expect(page).to have_content 'ユーザー名を変更しました'
  end

  it 'ユーザー名が空の場合、エラーメッセージが表示される' do
    fill_in 'new_name', with: ''
    click_button '変更'
    expect(page).to have_content 'ユーザー名の変更に失敗しました'
  end
end
