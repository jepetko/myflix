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