module PageMetrics
  class Engine < ::Rails::Engine
    isolate_namespace PageMetrics

    # hmmm... necessary?
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :fabrication, :dir => 'spec/fabricators'
    end

  end
end
