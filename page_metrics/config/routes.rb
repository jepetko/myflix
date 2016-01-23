PageMetrics::Engine.routes.draw do
  resources :metrics, only: [:index]
end
