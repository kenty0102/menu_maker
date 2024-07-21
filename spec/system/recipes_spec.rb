require 'rails_helper'

RSpec.describe 'Recipes', type: :system do
  let(:user) { create(:user) }

  before do
    login(user)
    click_link 'レシピ保存'
  end

  describe 'レシピの自動保存' do
    it 'レシピの自動保存が成功すること' do
      visit auto_save_recipes_path
      fill_in 'recipe_source_url', with: 'https://cookpad.com/recipe/7868632'
      click_button 'レシピを保存'

      expect(page).to have_content('レシピを保存しました')
    end

    it '保存されたレシピのタイトルが表示されること' do
      visit auto_save_recipes_path
      fill_in 'recipe_source_url', with: 'https://cookpad.com/recipe/7868632'
      click_button 'レシピを保存'
      expect(page).to have_content('アイスバナナソイラテ☆フルーツコーヒー')
    end
  end

  describe 'レシピの手動保存' do
    before do
      visit new_recipe_path
      fill_in 'recipe_title', with: 'Test Recipe'
      fill_in 'recipe_ingredients_attributes_0_name', with: 'Test Ingredient'
      fill_in 'recipe_ingredients_attributes_0_unit', with: 'g'
      fill_in 'recipe_instructions_attributes_0_description', with: 'Test Instruction'
      attach_file 'recipe_image', Rails.root.join('spec/fixtures/files/sample.jpg')
    end

    it 'タイトルを正しく入力できること' do
      expect(page).to have_field('recipe_title', with: 'Test Recipe')
    end

    it '材料名を正しく入力できること' do
      expect(page).to have_field('recipe_ingredients_attributes_0_name', with: 'Test Ingredient')
    end

    it '材料の単位を正しく入力できること' do
      expect(page).to have_field('recipe_ingredients_attributes_0_unit', with: 'g')
    end

    it '手順を正しく入力できること' do
      expect(page).to have_field('recipe_instructions_attributes_0_description', with: 'Test Instruction')
    end

    it '画像を正しくアップロードできること' do
      click_button 'レシピを保存'
      expect(page).to have_selector("img[src$='sample.jpg']")
    end

    it 'レシピの手動保存が成功すること' do
      click_button 'レシピを保存'
      expect(page).to have_content('レシピを保存しました')
    end

    it '作成されたレシピのタイトルが表示されること' do
      click_button 'レシピを保存'
      expect(page).to have_content('Test Recipe')
    end
  end

  describe 'レシピの編集' do
    before do
      visit new_recipe_path
      fill_in 'recipe_title', with: 'Test Recipe'
      fill_in 'recipe_ingredients_attributes_0_name', with: 'Test Ingredient'
      fill_in 'recipe_ingredients_attributes_0_unit', with: 'g'
      fill_in 'recipe_instructions_attributes_0_description', with: 'Test Instruction'
      attach_file 'recipe_image', Rails.root.join('spec/fixtures/files/sample.jpg')
      click_button 'レシピを保存'
    end

    it 'レシピが更新されたメッセージが表示される' do
      click_link '編集'
      fill_in 'recipe_title', with: '更新されたレシピ'
      click_button 'レシピを更新'
      expect(page).to have_content 'レシピを更新しました'
    end

    it '更新されたレシピのタイトルが表示される' do
      click_link '編集'
      fill_in 'recipe_title', with: '更新されたレシピ'
      click_button 'レシピを更新'
      expect(page).to have_content '更新されたレシピ'
    end
  end

  describe 'レシピの削除' do
    before do
      visit new_recipe_path
      fill_in 'recipe_title', with: 'Test Recipe'
      fill_in 'recipe_ingredients_attributes_0_name', with: 'Test Ingredient'
      fill_in 'recipe_ingredients_attributes_0_unit', with: 'g'
      fill_in 'recipe_instructions_attributes_0_description', with: 'Test Instruction'
      attach_file 'recipe_image', Rails.root.join('spec/fixtures/files/sample.jpg')
      click_button 'レシピを保存'
    end

    it 'レシピが削除されたメッセージが表示される' do
      page.accept_alert('このレシピを削除しますか？') do
        click_link '削除'
      end
      expect(page).to have_content 'レシピを削除しました'
    end

    it '削除されたレシピのタイトルが一覧に表示されない' do
      page.accept_alert('このレシピを削除しますか？') do
        click_link '削除'
      end
      expect(page).not_to have_content 'Test Recipe'
    end
  end

  describe 'レシピの詳細表示' do
    before do
      visit new_recipe_path
      fill_in 'recipe_title', with: 'Test Recipe'
      fill_in 'recipe_ingredients_attributes_0_name', with: 'Test Ingredient'
      fill_in 'recipe_ingredients_attributes_0_unit', with: 'g'
      fill_in 'recipe_instructions_attributes_0_description', with: 'Test Instruction'
      attach_file 'recipe_image', Rails.root.join('spec/fixtures/files/sample.jpg')
      click_button 'レシピを保存'
    end

    it 'レシピのタイトルが詳細に表示される' do
      expect(page).to have_content('Test Recipe')
    end

    it 'レシピの食材名が詳細に表示される' do
      expect(page).to have_content('Test Ingredient')
    end

    it 'レシピの食材の単位が詳細に表示される' do
      expect(page).to have_content('g')
    end

    it 'レシピの手順が詳細に表示される' do
      expect(page).to have_content('Test Instruction')
    end
  end
end
