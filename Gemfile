source 'https://rubygems.org'
ruby '2.1.7'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails', '~> 0.9'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form', '~> 2.3.0'
gem 'bcrypt', '~> 3.1.2'
gem 'mailgun_rails'
gem 'sidekiq'
gem 'unicorn-rails'
gem 'carrierwave-aws'
gem 'mini_magick'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'fabrication', '~> 2.13.2'
  gem 'faker'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'capybara'
  gem 'capybara-email'
end

group :staging, :production do
  gem 'rails_12factor'
end

group :production do
  gem 'sentry-raven'
end

