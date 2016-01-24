This is myflix, a simplified netflix application.

![CircleCI state](https://circleci.com/gh/jepetko/myflix.png?circle-token=1af4af3ace9ad752f06f9dd86385bc2683adff3e&style=shield)

# adding mountable engine page_metrics

## generate it

```bash
rails plugin new page_metrics -T --mountable --full --dummy-path=spec/test_app
```

## use rspec instead of test-unit

Gemfile:
```
gem 'rspec-rails', '~> 3.0'
gem 'fabrication', '~> 2.13.2'
```

engine.rb 
```ruby
  config.generators do |g|
    g.test_framework :rspec
    g.fixture_replacement :fabrication, :dir => 'spec/fabricators'
  end
```

install rspec:
```
rails generate rspec:install
```

execute:
```
cd page_metrics
bundle exec rspec
```

Maybe more changes are necessary...

## implement page metrics

write test (note; you will need to trigger the event manually):
```ruby
require 'rails_helper'

describe PageMetrics::Engine do

  let(:event) { 'process_action.action_controller' }
  let(:payload) { { path: '/'} }

  before do
    # produce a notification
    ActiveSupport::Notifications.instrument event, payload do
      sleep(0.001)
    end
  end

  it 'saves the page metric' do
    expect(PageMetrics::Metric.count).to be 1
    expect(PageMetrics::Metric.first.name).to eq event
  end

end
```

write the model and migration accordingly 

Place: 
```
page_metrics/app/models/page_metrics/metric.rb
```

install the migration into the MAIN application
```
# the current folder is the main application !!!
bundle exec rake page_metrics:install:migrations
bundle exec rake db:migrate # metrics table gets created
```

create a subscriber in the engine
```
# page_metrics/lib/page_metrics.rb
module PageMetrics
  ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
    PageMetrics::Metric.create name: args.first, payload: args.slice(1, args.size)
  end unless Rails.env.test?
end
```

## write the controller, view and model decorator

controller:
```
# in page_metrics/app/controllers/page_metrics/metrics_controller.rb
module PageMetrics
  class MetricsController < PageMetrics::ApplicationController
    def index
      @metrics = Metric.all
    end
  end
end
```

view:
```haml
# in page_metrics/app/views/page_metrics/index.html.haml 
%table.table
  - @metrics.each do |metric|
    = render 'page_metrics/metrics/metric', metric: metric.decorate
```

```
# in page_metrics/app/views/page_metrics/_metric.html.haml
%tr.tr
  %td
    = metric[:name]
  %td
    = metric.duration_in_words
```

decorator implementation:
```
# in page_metrics/app/decorators/page_metrics/metric_decorator.rb
module PageMetrics
  class MetricDecorator < ::Draper::Decorator
    delegate_all

    def duration
      return nil if !payload
      (time_end - time_start).to_f * 1000
    end

    def duration_in_words
      #...
    end

    # more methods...
  end
end
```

