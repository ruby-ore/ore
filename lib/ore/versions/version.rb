require 'ore/versions/exceptions/invalid_version'

require 'rubygems/version'

module Ore
  module Versions
    #
    # Represents a standard three-number version.
    #
    # @see http://semver.org/
    #
    class Version < Gem::Version

      # The version string
      attr_reader :version

      # Major version number
      attr_reader :major

      # Minor version number
      attr_reader :minor

      # Patch version number
      attr_reader :patch

      #
      # Creates a new version.
      #
      # @param [Integer, nil] major
      #   The major version number.
      #
      # @param [Integer, nil] minor
      #   The minor version number.
      #
      # @param [Integer, nil] patch
      #   The patch version number.
      #
      # @param [Integer, nil] build (nil)
      #   The build version number.
      #
      def initialize(major,minor,patch,build=nil)
        @major = (major || 0)
        @minor = (minor || 0)
        @patch = (patch || 0)
        @build = build

        numbers = [@major,@minor,@patch]
        numbers << @build if  @build

        super(numbers.join('.'))
      end

      #
      # Parses a version string.
      #
      # @param [String] string
      #   The version string.
      #
      # @return [Version]
      #   The parsed version.
      #
      def self.parse(string)
        major, minor, patch, build = string.split('.',4)

        return self.new(
          major || 0,
          minor || 0,
          patch || 0,
          build
        )
      end

    end
  end
end
