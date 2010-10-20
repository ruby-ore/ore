module Ore
  class Dependency

    # The name of the dependency
    attr_reader :name

    # The required versions
    attr_reader :versions

    #
    # Creates a new dependency.
    #
    # @param [String] name
    #   The name of the dependency.
    #
    # @param [Array<String>] versions
    #   The required versions.
    #
    def initialize(name,*versions)
      @name = name
      @versions = versions
    end

    #
    # Parses a version string.
    #
    # @param [String] name
    #   The name of the dependency.
    #
    # @param [String, nil] versions 
    #   The version string.
    #
    # @return [Dependency]
    #   The parsed dependency.
    #
    def self.parse_versions(name,versions)
      versions = if version.kind_of?(String)
                   versions.strip.split(/,\s*/)
                 else
                   []
                 end

      return new(name,*versions)
    end

    #
    # Parses a dependencey string.
    #
    # @param [String] dependency
    #   The dependencey string.
    #
    # @return [Dependency]
    #   The parsed dependency.
    #
    def self.parse(dependency)
      name, versions = dep.strip.split(/\s+/,2)

      return parse_versions(name,versions)
    end

  end
end
