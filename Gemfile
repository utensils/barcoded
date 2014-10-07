source 'https://rubygems.org'

gem 'activesupport'
gem 'barby'
gem 'builder'
gem 'rmagick', require: false
gem 'rqrcode'
gem 'sinatra'
gem 'sinatra-cross_origin'
gem 'sinatra-contrib'

group :development, :test do
  gem 'icepick'
  gem 'rake'
end

group :test do
  gem 'coveralls', require: false
  gem 'rack-test'
  gem 'rr'
  gem 'rspec'
  gem 'simplecov', require: false
end

group :production do
  gem 'unicorn', '~> 4.8.3'
end
