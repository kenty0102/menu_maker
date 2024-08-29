require 'rails_helper'

RSpec.describe '検索機能', type: :system do
  let(:user) { create(:user) }

  before do
    login(user)
  end

  describe 'レシピ一覧ページ' do
    before do
      create(:recipe, user:, title: 'サンプルレシピ1')
      create(:recipe, user:, title: 'テストレシピ', ingredients: [create(:ingredient, name: 'サンプル材料')])
      visit recipes_path
    end

    it 'レシピタイトルの部分一致でレシピを検索できる' do
      fill_in 'q_title_cont', with: 'サンプル'
      click_button '検索'
      expect(page).to have_content('サンプルレシピ1')
    end

    it 'レシピタイトルが一致しないレシピは検索されない' do
      fill_in 'q_title_cont', with: 'サンプル'
      click_button '検索'
      expect(page).not_to have_content('テストレシピ')
    end

    it '材料名の部分一致でレシピを検索できる' do
      fill_in 'q_ingredients_name_cont', with: 'サンプル材料'
      click_button '検索'
      expect(page).to have_content('テストレシピ')
    end

    it '材料名が一致しないレシピは検索されない' do
      fill_in 'q_ingredients_name_cont', with: 'サンプル材料'
      click_button '検索'
      expect(page).not_to have_content('サンプルレシピ1')
    end
  end

  describe 'メニュー表作成ページ' do
    before do
      create(:recipe, user:, title: 'サンプルレシピ1')
      create(:recipe, user:, title: 'テストレシピ', ingredients: [create(:ingredient, name: 'サンプル材料')])
      visit new_menu_path
    end

    it 'レシピタイトルの部分一致でレシピを絞り込める' do
      fill_in 'q_title_cont', with: 'サンプル'
      click_button '絞り込み'
      expect(page).to have_content('サンプルレシピ1')
    end

    it 'レシピタイトルが一致しないレシピは絞り込み時に表示されない' do
      fill_in 'q_title_cont', with: 'サンプル'
      click_button '絞り込み'
      expect(page).not_to have_content('テストレシピ')
    end

    it '材料名の部分一致でレシピを絞り込める' do
      fill_in 'q_ingredients_name_cont', with: 'サンプル材料'
      click_button '絞り込み'
      expect(page).to have_content('テストレシピ')
    end

    it '材料名が一致しないレシピは絞り込み時に表示されない' do
      fill_in 'q_ingredients_name_cont', with: 'サンプル材料'
      click_button '絞り込み'
      expect(page).not_to have_content('サンプルレシピ1')
    end
  end

  describe 'メニュー表一覧ページ' do
    let(:design) { create(:design) }

    before do
      create(:menu, user:, title: 'サンプルメニュー', design:, recipes: [create(:recipe, title: 'サンプルレシピ')])
      create(:menu, user:, title: 'テストメニュー', design:, recipes: [create(:recipe, title: 'テストレシピ')])
      visit menus_path
    end

    it 'メニュータイトルの部分一致でメニュー表を検索できる' do
      fill_in 'q_title_cont', with: 'サンプル'
      click_button '検索'
      expect(page).to have_content('サンプルメニュー')
    end

    it 'メニュータイトルが一致しないメニュー表は検索されない' do
      fill_in 'q_title_cont', with: 'サンプル'
      click_button '検索'
      expect(page).not_to have_content('テストメニュー')
    end

    it 'メニュー表に含まれるレシピタイトルの部分一致でメニュー表を検索できる' do
      fill_in 'q_recipes_title_cont', with: 'テストレシピ'
      click_button '検索'
      expect(page).to have_content('テストメニュー')
    end

    it 'レシピタイトルが一致しない場合はメニュー表は検索されない' do
      fill_in 'q_recipes_title_cont', with: 'テストレシピ'
      click_button '検索'
      expect(page).not_to have_content('サンプルメニュー')
    end
  end
end
