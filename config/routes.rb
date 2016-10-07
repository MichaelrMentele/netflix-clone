Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get '/home', to: 'categories#index'
  get '/genre/:id', to: 'categories#show'
  get '/video/:id', to: 'videos#show'
end
