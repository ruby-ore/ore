require 'pathname'

module Ore
  module Config
    # The users home directory
    @@home = File.expand_path(ENV['HOME'] || ENV['HOMEPATH'])

    # Ore config directory
    @@path = File.join(@@home,'.ore')

    # Default `ore` options file.
    @@options_file = File.join(@@path,'default.opts')

    # Custom Ore Templates directory
    @@templates_dir = File.join(@@path,'templates')

    # The `data/` directory for Ore
    @@data_dir = File.expand_path(File.join('..','..','data'),File.dirname(__FILE__))

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
      if File.directory?(@@templates_dir)
        Dir.glob("#{@@templates_dir}/*") do |template|
          yield template if File.directory?(template)
        end
      end
    end
  end
end
