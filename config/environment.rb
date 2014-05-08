require 'active_support'
require 'active_support/core_ext/hash/conversions'
require 'bundler/setup'
require 'json'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/cross_origin'

ENV['RACK_ENV']           ||= 'development'
ENV['RACK_CORS']          ||= 'disabled'
ENV['RACK_CORS_ORIGINS']  ||= '*'

Bundler.require(:default, ENV['RACK_ENV'])

path = File.join(Dir.pwd, '{config/initializers,lib}', '**', '*.rb')
Dir[path].each { |file| require file }
