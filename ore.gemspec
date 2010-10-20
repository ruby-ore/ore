lib_dir = File.expand_path('lib')
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'ore/specification'

Ore::Specification.new
