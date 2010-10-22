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
    # The builtin templates.
    #
    # @yield [path]
    #   The given block will be passed every builtin template.
    #
    # @yieldparam [String] path
    #   The path of a Ore template directory.
    #
    def Config.builtin_templates(&block)
      path = File.join(DATA_DIR,'ore','templates')

      if File.directory?(path)
        Dir.glob("#{path}/*",&block)
      end
    end

    #
    # The installed templates.
    #
    # @yield [path]
    #   The given block will be passed every installed template.
    #
    # @yieldparam [String] path
    #   The path of a Ore template directory.
    #
    def Config.installed_templates(&block)
      if File.directory?(TEMPLATES_DIR)
        Dir.glob("#{TEMPLATES_DIR}/*",&block)
      end
    end
  end
end
