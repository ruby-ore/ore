require 'ore/config'
require 'ore/template'

module Ore
  #
  # @api semipublic
  #
  # @since 0.9.0
  #
  module Options
    # Default version
    DEFAULT_VERSION = '0.1.0'

    # Default summary
    DEFAULT_SUMMARY = %q{TODO: Summary}

    # Default description
    DEFAULT_DESCRIPTION = %q{TODO: Description}

    def self.included(base)
      base.extend ClassMethods
    end

    #
    # Default options for the generator.
    #
    # @return [Hash{Symbol => Object}]
    #   The option names and default values.
    #
    def self.defaults
      @@defaults ||= {
        templates:      [],
        version:        DEFAULT_VERSION,
        summary:        DEFAULT_SUMMARY,
        description:    DEFAULT_DESCRIPTION,
        mit:            true,
        rubygems_tasks: true,
        rdoc:           true,
        rspec:          true,
        git:            true
      }.merge(Config.options)
    end

    module ClassMethods
      #
      # Defines a generator option.
      #
      # @param [Symbol] name
      #   The name of the option.
      #
      # @param [Hash{Symbol => Object}] options
      #   The Thor options of the option.
      #
      def generator_option(name,options={})
        class_option(name,options.merge(default: Options.defaults[name]))
      end
    end
  end
end
