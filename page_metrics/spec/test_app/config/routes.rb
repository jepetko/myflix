Rails.application.routes.draw do
  mount PageMetrics::Engine => "/page_metrics"
end
