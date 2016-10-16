Myflix::Application.routes.draw do
  root to: 'pages#splash'

  get 'ui(/:action)', controller: 'ui' unless Rails.env.production?

  ### Categories ###
  get '/home', to: 'categories#index'
  get '/genre/:id', to: 'categories#show', as: "category"

  ### Videos > Reviews ###
  resources :videos, only: [:show] do 
    collection do 
      post :search, to: "videos#search"
    end

    resources :reviews, only: [:create]
  end

  ### Queue ###
  get '/my_queue', to: 'queue_items#index'
  patch '/update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]

  ### Sessions ###
  get '/login', to: 'sessions#new'
  post '/logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  ### Users ###
  get '/register', to: 'users#new'
  resources :users, only: [:create, :show]

  get '/people', to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]
end
