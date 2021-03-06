Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
      api_key: Rails.application.secrets.mail_api_key,
      domain: Rails.application.secrets.mail_domain
  }
  config.action_mailer.default_url_options = {:host => 'leanetic-myflix.herokuapp.com'}

  config.action_dispatch.show_exceptions = false
end

Raven.configure do |config|
  config.dsn = Rails.application.secrets.sentry_api_key
  config.environments = %w{production}
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end