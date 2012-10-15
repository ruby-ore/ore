module Ore
  module Template
    #
    # The templates registered with the generator.
    #
    # @return [Hash{Symbol => String}]
    #   The template names and paths.
    #  
    # @api semipublic
    #
    # @since 0.9.0
    #
    def self.templates
      @@templates ||= {}
    end

    #
    # Determines whether a template was registered.
    #
    # @param [Symbol, String] name
    #   The name of the template.
    #
    # @return [Boolean]
    #   Specifies whether the template was registered.
    #
    # @api semipublic
    #
    # @since 0.9.0
    #
    def self.template?(name)
      self.templates.has_key?(name.to_sym)
    end

    #
    # Registers a template with the generator.
    #
    # @param [String] path
    #   The path to the template.
    #
    # @return [Symbol]
    #   The name of the registered template.
    #
    # @raise [StandardError]
    #   The given path was not a directory.
    #
    # @api semipublic
    #
    # @since 0.9.0
    #
    def self.register(path)
      unless File.directory?(path)
        raise(StandardError,"#{path.dump} is must be a directory")
      end

      name = File.basename(path).sub(/^ore-/,'').to_sym

      self.templates[name] = path
      return name
    end
  end
end
