Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', controller: 'home'

  resources :users, only: [:create, :show]
  get 'register', to: 'users#new'

#  post 'follow', to: 'relationships#create'
  match '/follow' => 'relationships#create', as: :follow, via: [:post]
  match '/unfollow' => 'relationships#destroy', as: :unfollow, via: [:delete]
  get 'people', to: 'relationships#index'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  delete 'sign_out', to: 'sessions#destroy'

  resources :categories, only: [:show]
  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]
end

