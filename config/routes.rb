Rails.application.routes.draw do
  root "static_pages#home"
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get '/signup', to: 'users#new'
  get "/help", to: "static_pages#help", as: 'help'
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"

  resources :users do
    member do
      get :following, :followers
    end
  end
  # get '/danh-sach-than-tuong/:id', to: 'users#following', as: 'following_list'

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  get '/microposts', to: 'static_pages#home'
end
