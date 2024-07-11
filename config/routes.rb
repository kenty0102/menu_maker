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
      get 'save_options'  # レシピ保存方法選択ページに対応するルート
      get 'auto_save'  # レシピ自動保存ページに対応するルート
      post 'fetch_recipe'  # レシピの自動取得アクション
    end
  end
  get 'login', to: 'user_sessions#new'  # ログインページに対応するルート
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
