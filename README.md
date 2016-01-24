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
```ruby
# page_metrics/lib/page_metrics.rb
module PageMetrics
  ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
    PageMetrics::Metric.create name: args.first, payload: args.slice(1, args.size)
  end unless Rails.env.test?
end
```

## write the controller, view and model decorator

controller:
```ruby
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

```haml
# in page_metrics/app/views/page_metrics/_metric.html.haml
%tr.tr
  %td
    = metric[:name]
  %td
    = metric.duration_in_words
```

write the test and load the fabricators accordingly:

```ruby
# page_metrics/spec/support/fabrication.rb
Fabrication.configure do |config|
  config.fabricator_path = 'spec/fabricators'
  config.path_prefix = File.expand_path(Rails.root, 'page_metrics')
end
```

```ruby
# page_metrics/spec/page_metrics_metric_decorator_spec.rb
require 'spec_helper'

describe PageMetrics::MetricDecorator do

  describe '#duration' do

    let(:start) { Time.current }
    let(:metric_less_than_one_minute) { Fabricate(:metric, payload: [start, start + 0.5.second])}

    it 'computes the duration of a fast request' do
      expect(metric_less_than_one_minute.duration).to eq(500)
      expect(metric_less_than_one_minute.duration_in_words).to eq('500 milliseconds')
    end
  end

end
```

decorator implementation:
```ruby
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

## customize the controller in the main app

write the feature test:
```ruby
require 'spec_helper'

feature 'admin sees page metrics' do

  scenario 'regular user cannot access the page metrics' do
    user = Fabricate(:user)
    sign_in user
    visit admin_page_metrics_path
    expect(page).to have_content 'You need to be an admin to do that'
  end
  # ...
end
```

hook into the engine and adapt the behaviour:
```ruby
# in myflix/app/decorators/page_metrics/metrics_controller_decorator.rb
PageMetrics::MetricsController.class_eval do

  # in order to access >>current_user<< method and so on...
  include ApplicationController::AuthMethods

  before_action :ensure_admin

  def ensure_admin
    if !current_user.admin?
      flash[:danger] = 'You need to be an admin to do that'
      # !!! access home_path by prefixing >>main_app<<
      redirect_to main_app.home_path
    end
  end

end
```

routes:
```ruby
# in main application
  namespace :admin do
    mount PageMetrics::Engine, at: '/page_metrics'
  end
```

```ruby
# in page_metrics/config/routes.rb
PageMetrics::Engine.routes.draw do
  get '/' => 'metrics#index'
end
```

# access it in the browser

http://localhost:3000/admin/page_metrics
