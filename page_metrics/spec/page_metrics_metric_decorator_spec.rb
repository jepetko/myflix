require 'spec_helper'

describe PageMetrics::MetricDecorator do

  describe '#duration' do

    let(:start) { Time.current }
    let(:metric_less_than_one_minute) { Fabricate(:metric, payload: [start, start + 0.5.second])}
    let(:metric_more_than_one_minute) { Fabricate(:metric, payload: [start, start + 1.minute + 1.second]) }
    it 'computes the duration of a slow request' do
      expect(metric_more_than_one_minute.duration).to eq(61000)
      expect(metric_more_than_one_minute.duration_in_words).to eq('1 minutes 1 seconds')
    end

    it 'computes the duration of a fast request' do
      expect(metric_less_than_one_minute.duration).to eq(500)
      expect(metric_less_than_one_minute.duration_in_words).to eq('500 milliseconds')
    end
  end

end
