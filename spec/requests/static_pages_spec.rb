require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /top" do
    it "renders the top page" do
      get root_path # root_pathはroot 'static_pages#top'によって生成されたヘルパーメソッドです
      expect(response).to have_http_status(200)
    end

    it "includes 'Menu Maker' in the body" do
      get root_path
      expect(response.body).to include("Menu Maker") # トップページに表示されるタイトルなどの内容を検証する例
    end
  end
end
