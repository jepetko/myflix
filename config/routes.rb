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

  # password services
  resources :passwords, only: [:new, :create, :edit, :update]
  get '/forgot_password', to: 'passwords#new'
  post '/forgot_password', to: 'passwords#create'
  get '/reset_password/:token', to: 'passwords#edit', as: :reset_password
  put '/reset_password/:token', to: 'passwords#update'

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

  # invitations
  resources :invitations, only: [:new, :create, :show]
  get '/invite', to: 'invitations#new'
  post '/invite', to: 'invitations#create'
  get '/confirm_invitation/:token', to: 'invitations#show', as: :confirm_invitation

  get '/advanced_search', to: 'videos#advanced_search'

  # admin role
  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
    mount PageMetrics::Engine, at: '/page_metrics'
  end

  mount StripeEvent::Engine, at: '/stripe_events'
end