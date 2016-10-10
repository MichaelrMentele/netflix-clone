Myflix::Application.routes.draw do
  root to: 'pages#splash'

  # REMOVE FOR PRODUCTION #
  get 'ui(/:action)', controller: 'ui'
  #########################

  get '/home', to: 'categories#index'
  get '/genre/:id', to: 'categories#show'

  resources :videos, only: [:show] do 
    collection do 
      post :search, to: "videos#search"
    end

    resources :reviews, only: [:create]
  end

  get '/login', to: 'sessions#new'
  post '/logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  get '/register', to: 'users#new'
  resources :users, only: [:create]
end
