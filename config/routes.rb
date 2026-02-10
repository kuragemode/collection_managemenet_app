Rails.application.routes.draw do
  devise_for :users
  resources :items
  
  # トップページ（/）へのアクセスを items#index に向ける
  # ※ authenticate_user! があるので、ログインしていないとここは開けず、ログイン画面に飛びます
  root "items#index"
end