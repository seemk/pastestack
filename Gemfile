source 'https://rubygems.org'
ruby '2.1.1'

gem 'rails', '4.0.5'
gem 'bcrypt-ruby'
gem 'bootstrap-sass'
gem 'sprockets', '2.11.0'
gem 'redis'
gem 'faye-websocket'
gem 'puma'
gem 'omniauth-google-oauth2'
gem 'dotenv-rails'

gem 'squeel'

group :development do
    gem 'sqlite3'
end

group :development, :test do
    gem 'rspec-rails'
    gem 'guard-rspec'
    gem 'spork-rails'
    gem 'guard-spork'
    gem 'childprocess'
end

group :test do
    gem 'selenium-webdriver'
    gem 'capybara'
    gem 'rails-perftest'
    gem 'ruby-prof'
    gem 'celluloid'
    gem "factory_girl_rails", "~> 4.0"
end

group :production, :test do
    gem 'pg', '0.17.1'
end

gem 'sass-rails', '4.0.1'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
    gem 'rails_12factor', '0.0.2'
    gem 'heroku_rails_deflate'
end
