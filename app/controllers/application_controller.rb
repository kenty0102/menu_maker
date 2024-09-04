class ApplicationController < ActionController::Base
  before_action :set_default_meta_tags
  before_action :require_login
  skip_before_action :require_login, if: -> { request.path.start_with?('/pages/') }
  add_flash_types :success, :danger

  private

  def not_authenticated
    redirect_to root_path
  end

  def set_default_meta_tags
    set_meta_tags(
      site: "Menu Maker", # アプリのタイトル
      title: "Welcome to Menu Maker", # デフォルトのページタイトル
      description: "Menu Makerは、自分だけのオリジナルメニューを簡単に作成し、シェアできるアプリです。多彩なレシピを組み合わせて、特別な料理体験を提供します。", # デフォルトの説明
      keywords: "メニュー, レシピ, オリジナルメニュー, メニュー表, 料理", # デフォルトのキーワード
      og: {
        title: :title, # ページ固有のタイトルがあればそれを使う
        description: :description, # ページ固有の説明があればそれを使う
        type: 'website',
        url: request.original_url,
        image: view_context.image_url('default_ogp.jpg') # デフォルトのOGP画像
      },
      twitter: {
        card: 'summary'
      }
    )
  end
end
