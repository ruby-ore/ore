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

    #
    # The installed templates.
    #
    # @return [Array<Pathname>]
    #   The paths of the installed Ore templates.
    #
    def Config.templates
      TEMPLATES_DIR.entries.select { |path| path.directory? }
    end
  end
end
