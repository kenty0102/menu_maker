require 'rails_helper'

RSpec.describe 'SNSシェア機能', type: :system do
  let(:user) { create(:user) }
  let!(:recipe) { create(:recipe, source_site_name: "") }
  let!(:design) { create(:design) }
  let!(:menu) { create(:menu, recipes: [recipe], design:) }

  before do
    login(user)
  end

  describe 'メニュー詳細ページ' do
    before do
      visit menu_path(menu)
    end

    context 'when X' do
      it 'Xのシェアボタンが表示される' do
        expect(page).to have_selector('a.twitter-share-button.x-icon-menu')
      end

      it 'Xのシェアボタンのリンクが正しいURLを持つ' do
        twitter_share_link = find('a.twitter-share-button.x-icon-menu')
        expect(twitter_share_link[:href]).to include("https://twitter.com/share")
      end

      it 'Xのシェアボタンのリンクがメニュータイトルを含む' do
        twitter_share_link = find('a.twitter-share-button.x-icon-menu')
        actual_url = twitter_share_link[:href]
        decoded_url = URI.decode_www_form_component(actual_url)
        expect(decoded_url).to include("text=【#{menu.title}】")
      end

      it 'XのシェアボタンのリンクがメニューのURLを含む' do
        twitter_share_link = find('a.twitter-share-button.x-icon-menu')
        expected_menu_url = "#{Capybara.app_host}/menus/#{menu.id}"
        expect(twitter_share_link[:href]).to include("url=#{expected_menu_url}")
      end
    end

    context 'when LINE' do
      it 'LINEのシェアボタンが表示される' do
        expect(page).to have_selector('a.line-share-button img.line-icon-menu')
      end

      it 'LINEのシェアボタンのリンクが正しいURLを持つ' do
        line_share_link = find('a.line-share-button.icon-menu')
        expect(line_share_link[:href]).to include("https://social-plugins.line.me/lineit/share")
      end

      it 'LINEのシェアボタンのリンクがメニュータイトルを含む' do
        line_share_link = find('a.line-share-button.icon-menu')
        actual_url = line_share_link[:href]
        decoded_url = URI.decode_www_form_component(actual_url)
        expect(decoded_url).to include("text=【#{menu.title}】")
      end

      it 'LINEのシェアボタンのリンクがメニューのURLを含む' do
        line_share_link = find('a.line-share-button.icon-menu')
        expected_menu_url = "#{Capybara.app_host}/menus/#{menu.id}"
        expect(line_share_link[:href]).to include("url=#{expected_menu_url}")
      end
    end
  end

  describe 'レシピ詳細ページ（自作レシピ）' do
    before do
      visit recipe_path(recipe)
    end

    context 'when X' do
      it 'Xのシェアボタンが表示される（自作レシピ）' do
        expect(page).to have_selector('a.twitter-share-button.x-icon-recipe')
      end

      it 'Xのシェアボタンのリンクが正しいURLを持つ（自作レシピ）' do
        twitter_share_link = find('a.twitter-share-button.x-icon-recipe')
        expect(twitter_share_link[:href]).to include("https://twitter.com/share")
      end

      it 'Xのシェアボタンのリンクがレシピタイトルを含む（自作レシピ）' do
        twitter_share_link = find('a.twitter-share-button.x-icon-recipe')
        actual_url = twitter_share_link[:href]
        decoded_url = URI.decode_www_form_component(actual_url)
        expect(decoded_url).to include("text=【#{recipe.title}】")
      end

      it 'XのシェアボタンのリンクがレシピのURLを含む（自作レシピ）' do
        twitter_share_link = find('a.twitter-share-button.x-icon-recipe')
        expected_recipe_url = "#{Capybara.app_host}/recipes/#{recipe.id}"
        expect(twitter_share_link[:href]).to include("url=#{expected_recipe_url}")
      end
    end

    context 'when LINE' do
      it 'LINEのシェアボタンが表示される（自作レシピ）' do
        expect(page).to have_selector('a.line-share-button img.line-icon-recipe')
      end

      it 'LINEのシェアボタンのリンクが正しいURLを持つ（自作レシピ）' do
        line_share_link = find('a.line-share-button.icon-recipe')
        expect(line_share_link[:href]).to include("https://social-plugins.line.me/lineit/share")
      end

      it 'LINEのシェアボタンのリンクがレシピタイトルを含む（自作レシピ）' do
        line_share_link = find('a.line-share-button.icon-recipe')
        actual_url = line_share_link[:href]
        decoded_url = URI.decode_www_form_component(actual_url)
        expect(decoded_url).to include("text=【#{recipe.title}】")
      end

      it 'LINEのシェアボタンのリンクがレシピのURLを含む（自作レシピ）' do
        line_share_link = find('a.line-share-button.icon-recipe')
        expected_recipe_url = "#{Capybara.app_host}/recipes/#{recipe.id}"
        expect(line_share_link[:href]).to include("url=#{expected_recipe_url}")
      end
    end
  end

  describe 'フッターのシェアボタン' do
    before do
      visit root_path
    end

    context 'when X' do
      it 'フッターのXシェアボタンが表示される' do
        expect(page).to have_selector('a.twitter-share-button.x-icon-footer')
      end

      it 'フッターのXシェアボタンのリンクが正しいURLを持つ' do
        twitter_share_link = find('a.twitter-share-button.x-icon-footer')
        expect(twitter_share_link[:href]).to include("https://twitter.com/share")
      end

      it 'フッターのXシェアボタンのリンクがサイトタイトルを含む' do
        twitter_share_link = find('a.twitter-share-button.x-icon-footer')
        actual_url = twitter_share_link[:href]
        decoded_url = URI.decode_www_form_component(actual_url)
        expect(decoded_url).to include("text=【Menu Maker】")
      end

      it 'フッターのXシェアボタンのリンクがサイトのURLを含む' do
        twitter_share_link = find('a.twitter-share-button.x-icon-footer')
        expected_root_url = "#{Capybara.app_host}/"
        expect(twitter_share_link[:href]).to include("url=#{expected_root_url}")
      end
    end

    context 'when LINE' do
      it 'フッターのLINEシェアボタンが表示される' do
        expect(page).to have_selector('a.line-share-button img.line-icon-footer')
      end

      it 'フッターのLINEシェアボタンのリンクが正しいURLを持つ' do
        line_share_link = find('a.line-share-button.icon-footer')
        expect(line_share_link[:href]).to include("https://social-plugins.line.me/lineit/share")
      end

      it 'フッターのLINEシェアボタンのリンクがサイトタイトルを含む' do
        line_share_link = find('a.line-share-button.icon-footer')
        actual_url = line_share_link[:href]
        decoded_url = URI.decode_www_form_component(actual_url)
        expect(decoded_url).to include("text=【Menu Maker】")
      end

      it 'フッターのLINEシェアボタンのリンクがサイトのURLを含む' do
        line_share_link = find('a.line-share-button.icon-footer')
        expected_root_url = "#{Capybara.app_host}/"
        expect(line_share_link[:href]).to include("url=#{expected_root_url}")
      end
    end
  end
end
