require 'ore/versions/exceptions/invalid_version'

require 'rubygems/version'

module Ore
  module Versions
    class Version < Gem::Version

      # The version string
      attr_reader :version

      # Major version number
      attr_reader :major

      # Minor version number
      attr_reader :minor

      # Patch version number
      attr_reader :patch

      def initialize(major,minor,patch,build=nil)
        @major = (major || 0)
        @minor = (minor || 0)
        @patch = (patch || 0)
        @build = build

        numbers = [@major,@minor,@patch]
        numbers << @build if  @build

        super(numbers.join('.'))
      end

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
