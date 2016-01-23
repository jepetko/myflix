module PageMetrics
  class MetricsController < PageMetrics::ApplicationController
    def index
      @metrics = Metric.all
    end
  end
end