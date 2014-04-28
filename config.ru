require 'logger'

$stdout.sync = true

require File.expand_path('config/environment')
require File.expand_path('barcoded') 

set :run, false

run Barcoded
