Rails.application.routes.draw do
  # メインページ
  get 'topics/:id/stock' => "topics#stock"
  # 編集ページとその後の処理
  get "topics/:id/edit" => "topic#edit"
  post "topics/:id/update" =>"topic#update"
  post "topics/:id/destroy" =>"topic#destroy"
  # 類題新規登録ページとその後の処理
  get "topics/:id/new" => "topics#new"
  post "topics/:id/create" => "topic#create"

  get "TopicStock" => "home#top"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
