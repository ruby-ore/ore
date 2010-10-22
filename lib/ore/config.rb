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
    # The available templates.
    #
    # @yield [path]
    #   The given block will be passed every template directory.
    #
    # @yieldparam [String] path
    #   The path of a Ore template directory.
    #
    def Config.each_template(&block)
      each_dir = lambda { |path|
        if File.directory?(path)
          Dir.glob("#{path}/*",&block)
        end
      }

      each_dir.call(File.join(DATA_DIR,'ore','templates'))
      each_dir.call(TEMPLATES_DIR)
    end
  end
end
