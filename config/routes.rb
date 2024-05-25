Rails.application.routes.draw do
  # ホームページ
  get  "/" => "home#top"
  # メインページ
  get  "topics/stock" => "topics#stock"
  # 検索フォーム
  get  "search" => "searches#search"
  get  "user_search" => "searches#user_search"
  # ログインページとログアウト処理
  get  "login_form" => "users#login_form"
  post "login" => "users#login"
  post "signup" => "users#signup"
  post "logout" => "users#logout"
  # ユーザーのホームページ idはユーザーのid
  get  "users/:id" => "users#home"
  get  "users/:id/stock" => "users#stock"
  get  "users/:id/new" => "users#new"
  post "users/:id/create" => "users#create"
  # 編集ページ idはトピックのid
  get  "users/:id/edit" => "users#edit"
  post "users/:id/update" =>"users#update"
  post "users/:id/s_update" =>"users#s_update"
  post "users/:id/s_create" =>"users#s_create"
  get  "users/:id/delete" => "users#delete"
  post "users/:id/destroy" =>"users#destroy"
  post "users/:id/s_destroy" =>"users#s_destroy"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
