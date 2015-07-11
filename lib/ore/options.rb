require 'yaml'

module Ore
  #
  # Value object to contain `~/.ore/options.yml` data.
  #
  # @since 0.11.0
  #
  class Options

    # Default markup
    DEFAULT_MARKUP = 'markdown'

    # Default version
    DEFAULT_VERSION = '0.1.0'

    # Default summary
    DEFAULT_SUMMARY = %q{TODO: Summary}

    # Default description
    DEFAULT_DESCRIPTION = %q{TODO: Description}

    # Default templates
    DEFAULT_TEMPLATES = [
      :git,
      :mit,
      :rubygems_tasks,
      :rdoc,
      :rspec
    ]

    # Default options
    DEFAULTS = {
      markup:      DEFAULT_MARKUP,
      version:     DEFAULT_VERSION,
      summary:     DEFAULT_SUMMARY,
      description: DEFAULT_DESCRIPTION
    }
    DEFAULT_TEMPLATES.each { |name| DEFAULTS[name] = true }

    #
    # Initializes the options.
    #
    # @param [Hash{Symbol => Object}] options
    #   The options hash.
    #
    def initialize(options={})
      @options = DEFAULTS.merge(options)
    end

    #
    # Loads the options from a YAML file.
    #
    # @param [String] path
    #   Path to the options file.
    #
    # @return [Options]
    #   The loaded options.
    #
    # @raise [RuntimeError]
    #   The file contained malformed YAML.
    #
    def self.load(path)
      data = YAML.load_file(path)

      unless data.kind_of?(Hash)
        raise("#{path} must contain a YAML encoded Hash")
      end

      options = {}

      data.each do |key,value|
        options[key.to_sym] = value
      end

      return new(options)
    end

    #
    # Accesses an option.
    #
    # @param [Symbol] key
    #   The option name.
    #
    # @return [Object]
    #   The option value.
    #
    def [](key)
      @options[key]
    end

  end
end
