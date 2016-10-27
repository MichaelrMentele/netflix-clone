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
      get :advanced_search, to: "videos#advanced_search", as: :advanced_search
    end

    resources :reviews, only: [:create]
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
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
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  resources :users, only: [:create, :show]

  ### Followers/Leaders ###
  get '/people', to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]

  ### Forgot Password Workflow ###
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]

  ### Password Reset Workflow ###
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'pages#expired_token'

  ### Invitations Workflow ###
  resources :invitations, only: [:new, :create]

  mount StripeEvent::Engine => '/stripe_events'
end
