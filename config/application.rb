require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module MailConfig
  def load_mail_config
    mail_config_file = File.join(Rails.root, 'config', 'mail.yml')
    if File.exist?(mail_config_file)
      mail_config = YAML.load(File.open(mail_config_file, 'r'))[Rails.env]
      ENV['MAIL_USERNAME'] = mail_config['username']
      ENV['MAIL_PASSWORD'] = mail_config['password']
    end
  end
end

module Myflix
  class Application < Rails::Application
    include MailConfig
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end
    # load mail configuration
    load_mail_config
  end
end
