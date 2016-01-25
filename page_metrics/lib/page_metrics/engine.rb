module PageMetrics
  class Engine < ::Rails::Engine
    isolate_namespace PageMetrics

    # hmmm... necessary?
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :fabrication, :dir => 'spec/fabricators'
    end

    # load the decorators from the main app to override the behavior of the mountable engine
    config.to_prepare do
      Dir.glob(Rails.root + 'app/decorators/**/*_decorator.rb').each do |c|
        require_dependency(c)
      end
    end

  end
end
