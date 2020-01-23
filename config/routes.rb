Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :messages, only: [:index, :show]
  # resources :token, only: [:create, :show]
  
  resources :sessions, only: [:destroy]
  delete "/sessions" => 'sessions#destroy'
  get "/auth/:provider/callback" => 'sessions#create'




end
