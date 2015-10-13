Myflix::Application.configure do
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :letter_opener
  #config.action_mailer.delivery_method = :mailgun
  #config.action_mailer.mailgun_settings = {
  #    api_key: Rails.application.secrets.mail_api_key,
  #    domain: Rails.application.secrets.mail_domain
  #}
  config.action_mailer.default_url_options = {:host => 'localhost', port: 3000}

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = false
end
