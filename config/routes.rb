Myflix::Application.routes.draw do
  root to: 'home#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', controller: 'home'

  resource :users, only: [:create]
  get 'register', to: 'users#new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  resources :categories, only: [:show]
  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: 'videos#search'
    end
  end
end

