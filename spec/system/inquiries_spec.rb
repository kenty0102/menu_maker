require 'rails_helper'

RSpec.describe 'お問い合わせ', type: :system do
  it 'ユーザーが問い合わせを送信できること' do
    visit new_inquiry_path
    send_inquiry("Test User", "test@example.com", "This is a test inquiry.")
    expect(page).to have_content('お問い合わせメールを送信しました')
  end

  it '問い合わせ完了画面が表示されること' do
    visit new_inquiry_path
    send_inquiry("Test User", "test@example.com", "This is a test inquiry.")
    expect(page).to have_content('お問い合わせ完了')
  end

  it '名前の入力がない場合にエラーが表示されること' do
    visit new_inquiry_path
    page.accept_alert('この内容でメールを送信しますか？') do
      click_button '送信する'
    end
    expect(page).to have_content("お名前を入力してください")
  end

  it 'メールアドレスの入力がない場合にエラーが表示されること' do
    visit new_inquiry_path
    page.accept_alert('この内容でメールを送信しますか？') do
      click_button '送信する'
    end
    expect(page).to have_content("メールアドレスを入力してください")
  end

  it '問い合わせ内容の入力がない場合にエラーが表示されること' do
    visit new_inquiry_path
    page.accept_alert('この内容でメールを送信しますか？') do
      click_button '送信する'
    end
    expect(page).to have_content("お問い合わせ内容を入力してください")
  end
end
