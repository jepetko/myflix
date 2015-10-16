Raven.configure do |config|
  config.dsn = Rails.application.secrets.sentry_api_key
  config.environments = %w{development production}
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end

