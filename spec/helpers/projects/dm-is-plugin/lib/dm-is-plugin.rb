require 'dm-core'
require 'dm-is-plugin/is/plugin'

DataMapper::Model.append_extensions DataMapper::Is::Plugin
