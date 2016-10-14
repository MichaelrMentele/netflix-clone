Myflix::Application.routes.draw do
  root to: 'pages#splash'

  # REMOVE FOR PRODUCTION #
  get 'ui(/:action)', controller: 'ui'
  #########################

  get '/home', to: 'categories#index'
  get '/genre/:id', to: 'categories#show', as: "category"

  resources :videos, only: [:show] do 
    collection do 
      post :search, to: "videos#search"
    end

    resources :reviews, only: [:create]
  end

  get '/my_queue', to: 'queue_items#index'
  patch '/update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]

  get '/login', to: 'sessions#new'
  post '/logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  get '/register', to: 'users#new'
  resources :users, only: [:create, :show]
end
