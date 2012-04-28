require 'rubygems'
require 'pathname'

module Ore
  module Config
    # The users home directory
    HOME = Gem.user_home

    # Ore config directory
    PATH = File.join(HOME,'.ore')

    # Default options file.
    OPTIONS_FILE = File.join(PATH,'options.yml')

    # Custom Ore Templates directory
    TEMPLATES_DIR = File.join(PATH,'templates')

    # The `data/` directory for Ore
    DATA_DIR = File.expand_path(File.join('..','..','data'),File.dirname(__FILE__))

    # Specifies whether user settings will be loaded
    @@enabled = true

    #
    # Enables access to user settings.
    #
    # @since 0.5.0
    #
    def Config.enable!
      @@enabled = true
    end

    #
    # Disables access to user settings.
    #
    # @since 0.5.0
    #
    def Config.disable!
      @@enabled = false
    end

    #
    # Loads the default options from `~/.ore/options.yml`.
    #
    # @return [Hash]
    #   The loaded default options.
    #
    # @raise [RuntimeError]
    #   The `~/.ore/options.yml` did not contain a YAML encoded Hash.
    #
    # @since 0.9.0
    #
    def Config.options
      options = {}

      if (@@enabled && File.file?(OPTIONS_FILE))
        new_options = YAML.load_file(OPTIONS_FILE)

        # default options must be a Hash
        unless new_options.kind_of?(Hash)
          raise("#{OPTIONS_FILE} must contain a YAML encoded Hash")
        end

        new_options.each do |name,value|
          options[name.to_sym] = value
        end
      end

      return options
    end

    #
    # The builtin templates.
    #
    # @yield [path]
    #   The given block will be passed every builtin template.
    #
    # @yieldparam [String] path
    #   The path of a Ore template directory.
    #
    def Config.builtin_templates
      path = File.join(DATA_DIR,'ore','templates')

      if File.directory?(path)
        Dir.glob("#{path}/*") do |template|
          yield template if File.directory?(template)
        end
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
    def Config.installed_templates
      if @@enabled
        if File.directory?(TEMPLATES_DIR)
          Dir.glob("#{TEMPLATES_DIR}/*") do |template|
            yield template if File.directory?(template)
          end
        end
      end
    end
  end
end
