require 'bundler/setup'
require 'json'
require 'sinatra/base'

ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default, ENV['RACK_ENV'])

path = File.join(Dir.pwd, 'lib', '**', '*.rb')
Dir[path].each { |file| require file }
