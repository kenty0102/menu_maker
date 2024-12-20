Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  root 'static_pages#top'
  resources :users, only: %i[new create]
  resource :profile, only: %i[show] do
    collection do
      get 'edit_username'  # ユーザー名編集ページに対応するルート
      patch 'update_username'
      get 'edit_email'  # メールアドレス編集ページに対応するルート
      patch 'update_email'
      get 'edit_password'  # パスワード変更ページに対応するルート
      patch 'update_password'
    end
  end
  resources :password_resets, only: %i[new create edit update]
  resources :recipes do
    collection do
      get 'search'  # レシピ検索ページに対応するルート
      get 'search_show'  # 検索したレシピの詳細ページに対応するルート
      post 'save_recipe'  # 検索したレシピ詳細ページからレシピを保存するルート
      get 'save_options'  # レシピ保存方法選択ページに対応するルート
      get 'auto_save'  # レシピ自動保存ページに対応するルート
      post 'fetch_recipe'  # レシピの自動取得アクション
      get 'autocomplete_title' # レシピ名検索のautocomplete
      get 'autocomplete_ingredients' # 材料名検索のautocomplete
    end
  end
  resources :menus do
    collection do
      get 'autocomplete_title' # メニュータイトル検索のautocomplete
      get 'autocomplete_recipes' # レシピ名でのメニュー検索のautocomplete
      post 'upload_image' # メニュー表の画像アップロード
      post 'save_image_url' # アップロードした画像のURLを保存
      post 'reset_upload_flag' #作成、編集時に設定したフラグを削除
    end
  end
  # ログイン/ログアウト
  get 'login', to: 'user_sessions#new'  # ログインページに対応するルート
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  post 'oauth/callback', to: 'oauths#callback'
  # 静的ページ
  get '/terms', to: 'high_voltage/pages#show', id: 'terms' # 利用規約ページに対応するルート
  get '/privacy', to: 'high_voltage/pages#show', id: 'privacy' # プライバシーポリシーページに対応するルート
  get '/how_to_use', to: 'high_voltage/pages#show', id: 'how_to_use' # 使い方の説明ページに対応するルート
  # 問い合わせ
  resources :inquiries, only: [:new, :create] do
    get 'complete', on: :collection
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
