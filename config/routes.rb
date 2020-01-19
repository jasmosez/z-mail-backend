Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'sessions#google'
  resources :sessions, only: [:index]
  get "/auth/:provider/callback" => 'sessions#create'



end
