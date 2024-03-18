Rails.application.routes.draw do
  # ホームページ
  get  "TopicStock" => "home#top"
  # メインページ
  get  "topics/stock" => "topics#stock"

  # ログインページとログアウト処理
  get  "login_form" => "users#login_form"
  post "login" => "users#login"
  post "signup" => "users#signup"
  post "logout" => "users#logout"
  # ユーザーのホームページ idはユーザーのid
  get  "users/:id" => "users#home"
  get  "users/:id/stock" => "users#stock"
  # 編集ページ idはトピックのid
  get  "users/:id/edit" => "users#edit"
  post "users/:id/update" =>"users#update"
  delete "users/:id/destroy" =>"users#destroy"
  post "users/:id/s_update" =>"users#s_update"
  delete "users/:id/s_destroy" =>"users#s_destroy"
  post "users/:id/s_create" =>"users#s_create"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
