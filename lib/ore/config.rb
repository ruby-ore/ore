require 'pathname'

module Ore
  module Config
    # The users home directory
    HOME = Pathname.new(ENV['HOME'] || ENV['HOMEPATH'])

    # Ore config directory
    PATH = HOME.join('.ore')

    # Default `ore` options file.
    OPTIONS_FILE = PATH.join('default.opts')

    # Custom Ore Templates directory
    TEMPLATES_DIR = PATH.join('templates')
  end
end
