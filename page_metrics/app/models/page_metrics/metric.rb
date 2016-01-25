module PageMetrics
  class Metric < ActiveRecord::Base

    def payload=(value)
      value[3] = fix_params value[3]
      write_attribute :payload, value
    end

    private

    def fix_params(params)
      params.each do |key,value|
        params[key] = value.class.name if value && value.instance_variable_defined?('@original_filename')
        fix_params value if value.is_a?(Hash)
      end
    end
  end
end