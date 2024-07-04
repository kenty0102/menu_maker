require 'rails_helper'

RSpec.describe 'ログイン', type: :system do
  let(:user) { create(:user) }

  describe 'ログアウト' do
    before do
      login(user)
    end

    it 'ログアウトできること' do
      click_on 'ログアウト'
      expect(page).to have_link 'ログイン'
    end

    it 'ログアウト成功時にフラッシュメッセージが表示される' do
      click_on 'ログアウト'
      expect(page).to have_content('ログアウトしました')
    end

    it 'ログアウト後トップページへ遷移する' do
      click_on 'ログアウト'
      expect(page).to have_current_path(root_path)
    end
  end
end
