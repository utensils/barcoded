require 'simplecov'
require 'rack/test'
require 'coveralls'

ENV['RACK_ENV'] = 'test'

Coveralls.wear!

# Configure code coverage reporting
SimpleCov.start do
  add_filter '/spec/'
  coverage_dir 'docs/coverage'
end

# Load our env and service
require File.expand_path('config/environment.rb')
require File.expand_path('barcoded.rb')

# Load spec helpers and support classes
Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include RequestHelper
  config.mock_framework = :rr

  def app
    Barcoded 
  end
end

