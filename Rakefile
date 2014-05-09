require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'coveralls/rake/task'
require File.expand_path('config/environment')
# Require in additional Rake tasks
Dir.glob('lib/tasks/**/*.rake').each { |r| import r }
# Setup RSpec
RSpec::Core::RakeTask.new(:spec)

task default: :spec

