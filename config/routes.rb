Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get '/home', to: 'categories#index'
  get '/genre/:id', to: 'categories#show'

  resources :videos, only: [:show] do 
    collection do 
      post :search, to: "videos#search"
    end
  end
end
