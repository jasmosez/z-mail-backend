Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  
  resources :sessions, only: [:index]
  get "/auth/:provider/callback" => 'sessions#create'

  resources :messages, only: [:index, :show]
  resources :token, only: [:create, :show]



end
