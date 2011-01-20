gem 'rspec', '~> 2.4.0'
require 'rspec'

gem 'ore-core', '~> 0.1.0'
require 'ore/config'

Ore::Config.disable!
include Ore
