module PageMetrics
  class MetricDecorator < ::Draper::Decorator
    delegate_all

    def duration
      return nil if !payload
      (time_end - time_start).to_f * 1000
    end

    def duration_in_words
      measured_duration = duration
      return nil if !measured_duration
      [[1000, :milliseconds], [60, :seconds], [60, :minutes]].map do |count, unit|
        if measured_duration > 0
          measured_duration, rest = measured_duration.divmod(count)
          "#{rest.to_i} #{unit}" unless rest == 0
        end
      end.compact.reverse.join(' ')
    end

    def time_start
      Time.parse payload[0]
    end

    def time_end
      Time.parse payload[1]
    end
  end
end