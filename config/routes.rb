Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get 'home', controller: 'home'

  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: 'videos#search'
    end
  end
  resources :categories, only: [:show]
end
