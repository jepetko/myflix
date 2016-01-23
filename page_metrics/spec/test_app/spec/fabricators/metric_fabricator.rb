Fabricator(:metric, from: 'PageMetrics::MetricDecorator') do
  on_init { init_with(PageMetrics::Metric.new) }
  name 'action.controller'
  payload
end