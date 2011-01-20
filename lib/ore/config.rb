require 'pathname'

module Ore
  module Config
    # Specifies whether user settings will be loaded
    @@enabled = true

    # The users home directory
    @@home = File.expand_path(ENV['HOME'] || ENV['HOMEPATH'])

    # Ore config directory
    @@path = File.join(@@home,'.ore')

    # Default options file.
    @@options_file = File.join(@@path,'options.yml')

    # Custom Ore Templates directory
    @@templates_dir = File.join(@@path,'templates')

    # The `data/` directory for Ore
    @@data_dir = File.expand_path(File.join('..','..','data'),File.dirname(__FILE__))

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
    # @since 0.5.0
    #
    def Config.default_options
      options = {}

      if (@@enabled && File.file?(@@options_file))
        new_options = YAML.load_file(@@options_file)

        # default options must be a Hash
        unless new_options.kind_of?(Hash)
          raise("#{@@options_file} must contain a YAML encoded Hash")
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
      path = File.join(@@data_dir,'ore','templates')

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
      return unless @@enabled

      if File.directory?(@@templates_dir)
        Dir.glob("#{@@templates_dir}/*") do |template|
          yield template if File.directory?(template)
        end
      end
    end
  end
end
