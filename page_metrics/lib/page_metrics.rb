require "page_metrics/engine"

module PageMetrics
  ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
    PageMetrics::Metric.create name: args.first, payload: args.slice(1, args.size)
  end
end
