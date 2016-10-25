source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.1'
gem 'jquery-rails'
gem 'bootstrap_form'

gem 'bcrypt'      # password hashing
gem 'sidekiq'     # multithreaded background workers

gem 'carrierwave' # uploading
gem 'mini_magick' # image processing

gem 'stripe'      # payment processing
gem 'stripe_event' # webhooks

gem 'figaro'      # sensitive info management

# better search
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# assets pipeline
gem 'bootstrap-sass', '3.1.1.1'
gem 'coffee-rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'fabrication'
  gem 'faker'
end

group :test do
  gem 'database_cleaner', '1.4.1'
  gem 'shoulda-matchers', '2.7.0'
  gem 'vcr', '2.9.3' # record api requests reponses
  gem 'webmock', '< 2.0.0'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'selenium-webdriver'
end

group :production do
  gem 'carrierwave-aws' # file storage
  gem 'rails_12factor'
  gem 'puma' # Concurrent server
  gem 'pg' # Postgres
  gem 'sentry-raven' # Error aggregator
end

