gem 'rspec', '~> 2.4'
require 'rspec'
require 'helpers/matchers'

require 'ore/config'
Ore::Config.disable!

include Ore
