require 'rake'
require 'rake/testtask'

require File.expand_path('config/environment')
require 'dotenv/tasks'

Dir.glob('lib/tasks/**/*.rake').each { |r| import r }

task :default => [:test]

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
  t.libs.push 'spec'
  t.verbose = true
end
