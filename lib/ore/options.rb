require 'ore/config'
require 'ore/template'

module Ore
  #
  # @api semipublic
  #
  # @since 0.9.0
  #
  module Options
    # Defaults options
    DEFAULTS = {
      :templates      => [],
      :version        => '0.1.0',
      :summary        => 'TODO: Summary',
      :description    => 'TODO: Description',
      :license        => 'MIT',
      :authors        => [ENV['USER']],
      :gemspec_yml    => true,
      :rubygems_tasks => true,
      :rdoc           => true,
      :rspec          => true,
      :git            => true
    }

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
      @@defaults ||= DEFAULTS.merge(Config.options)
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
        class_option(name,options.merge(:default => Options.defaults[name]))
      end
    end
  end
end
