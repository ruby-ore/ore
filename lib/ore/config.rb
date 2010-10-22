require 'pathname'

module Ore
  module Config
    # The users home directory
    HOME = File.expand_path(ENV['HOME'] || ENV['HOMEPATH'])

    # Ore config directory
    PATH = File.join(HOME,'.ore')

    # Default `ore` options file.
    OPTIONS_FILE = File.join(PATH,'default.opts')

    # Custom Ore Templates directory
    TEMPLATES_DIR = File.join(PATH,'templates')

    # The `data/` directory for Ore
    DATA_DIR = File.expand_path(File.join('..','..','data'),File.dirname(__FILE__))

    #
    # The builtin templates used by Ore.
    #
    # @return [Array<String>]
    #   The paths of the builtin Ore templates.
    #
    def Config.builtin_templates
      Dir["#{DATA_DIR}/ore/templates/*"]
    end

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
