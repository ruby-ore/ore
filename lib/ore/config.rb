require 'ore/options'

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

    # The `data/ore` directory for Ore
    DATA_DIR = File.expand_path(File.join('..','..','data','ore'),File.dirname(__FILE__))

    # The `data/ore/templates` directory for Ore
    BUILTIN_TEMPLATES_DIR = File.join(DATA_DIR,'templates')

    @enabled = true

    #
    # Enables access to user config.
    #
    # @api private
    #
    # @since 0.5.0
    #
    def self.enable!
      @enabled = true
    end

    #
    # Disables access to user config.
    #
    # @api private
    #
    # @since 0.5.0
    #
    def self.disable!
      @enabled = false
    end

    #
    # Loads the default options from `~/.ore/options.yml`.
    #
    # @return [Options]
    #   The loaded default options.
    #
    # @raise [RuntimeError]
    #   The `~/.ore/options.yml` did not contain a YAML encoded Hash.
    #
    # @since 0.9.0
    #
    def self.options
      @options ||= if @enabled && File.file?(OPTIONS_FILE)
                     Options.load(OPTIONS_FILE)
                   else
                     Options.new
                   end
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
    def self.builtin_templates
      if File.directory?(BUILTIN_TEMPLATES_DIR)
        Dir.glob("#{BUILTIN_TEMPLATES_DIR}/*") do |template|
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
    def self.installed_templates
      return unless @enabled

      if File.directory?(TEMPLATES_DIR)
        Dir.glob("#{TEMPLATES_DIR}/*") do |template|
          yield template if File.directory?(template)
        end
      end
    end
  end
end
