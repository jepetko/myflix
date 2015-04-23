Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'home#front'

  get 'home', controller: 'home'

  resources :categories, only: [:show]
  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: 'videos#search'
    end
  end
end

