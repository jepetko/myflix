Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', controller: 'home'

  resource :users, only: [:create]
  get 'register', to: 'users#new'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'

  resources :categories, only: [:show]
  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: 'videos#search'
    end
  end
end

