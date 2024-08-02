require 'rails_helper'

RSpec.describe "メニュー", type: :system do
  let(:user) { create(:user) }
  let!(:design) { create(:design, name: '居酒屋風メニュー') }
  let(:recipe) { create(:recipe) }
  let(:menu) { create(:menu, user:, recipe_ids: [recipe.id]) }

  before do
    login(user)
    design
  end

  describe 'メニュー表の作成' do
    let!(:first_recipe) { create(:recipe, user:) } # メニュー表作成時に必要なレシピを作成

    before do
      click_link 'メニュー表作成'
    end

    it '新しいメニューを作成できること' do
      fill_in 'menu_title', with: 'New Menu'
      find("input[type='checkbox'][value='#{first_recipe.id}']").check
      click_button 'メニュー表を作成'
      expect(page).to have_content('メニュー表を作成しました')
    end

    it '新しいメニューに選択したレシピが表示されること' do
      fill_in 'menu_title', with: 'New Menu'
      find("input[type='checkbox'][value='#{first_recipe.id}']").check
      click_button 'メニュー表を作成'
      expect(page).to have_content(first_recipe.title)
    end
  end

  describe 'メニュー表の詳細確認' do
    before do
      menu.recipes << create(:recipe, user:) # メニューに関連付け
      menu.designs << design
    end

    it '作成したメニュー表が表示されること' do
      visit menu_path(menu)
      expect(page).to have_content(menu.title)
    end

    it 'メニュー表確認画面でレシピが表示されること' do
      visit menu_path(menu)
      expect(page).to have_content(menu.recipes.first.title)
    end
  end

  describe 'メニュー表の一覧表示' do
    let!(:first_recipe) { create(:recipe, user:) }

    before do
      menu.recipes << first_recipe # メニューに関連付け
    end

    it 'メニューの一覧に作成したメニューが表示されること' do
      click_link 'メニュー表一覧'
      expect(page).to have_content(menu.title)
    end
  end

  describe 'メニュー表の編集' do
    let!(:first_recipe) { create(:recipe, user:) } # 編集時に必要なレシピを作成

    before do
      menu.recipes << first_recipe # メニューに関連付け
    end

    it 'メニューを編集し、タイトルが更新されること' do
      visit edit_menu_path(menu)
      fill_in 'menu_title', with: 'Updated Menu'
      click_button 'メニュー表を更新'
      expect(page).to have_content('Updated Menu')
    end

    it 'メニュー編集後にレシピの変更が反映されること' do
      second_recipe = create(:recipe, user:)
      menu.recipes << second_recipe
      menu_update(first_recipe)
      click_button 'メニュー表を更新'
      expect(page).to have_content(second_recipe.title)
    end

    it 'メニュー編集後に削除したレシピが表示されないこと' do
      second_recipe = create(:recipe, user:)
      menu.recipes << second_recipe
      menu_update(first_recipe)
      click_button 'メニュー表を更新'
      expect(page).not_to have_content(first_recipe.title)
    end
  end

  describe 'メニュー表の削除' do
    it 'メニューを削除できること' do
      visit menu_path(menu)
      page.accept_alert('このメニュー表を削除しますか？') do
        click_button '削除'
      end
      expect(page).to have_content 'メニュー表を削除しました'
    end
  end
end
