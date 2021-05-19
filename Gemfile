source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'rails', '~> 5.2.2'

gem 'active_model_serializers', '~> 0.10'
gem 'aws-sdk-s3', '~> 1.0'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.2.1'
gem 'cancancan'
gem 'capybara-email'
gem 'cocoon'
gem 'coffee-rails', '~> 4.2'
gem 'decent_exposure', '3.0.0'
gem 'devise'
gem 'doorkeeper'
gem 'figaro'
gem 'gon'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'letter_opener'
gem 'mini_racer'
gem 'mysql2'
gem "octokit", "~> 4.0"
gem 'oj'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'redis-rails'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'skim'
gem 'slim-rails'
gem 'thinking-sphinx'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'
gem 'validate_url'
gem 'whenever', require: false
gem 'will_paginate', '~> 3.1.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rails-controller-testing' # If you are using Rails 5.x
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
