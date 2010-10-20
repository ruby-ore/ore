require 'ore/versions/exceptions/invalid_version'

module Ore
  module Versions
    class Version

      # The version string
      attr_reader :version

      # Major version number
      attr_reader :major

      # Minor version number
      attr_reader :minor

      # Patch version number
      attr_reader :patch

      def initialize(path)
        @path = File.expand_path(path)
        @version = nil

        load!
      end

      def self.find(root)
      end

      def to_s
        @version.to_s
      end

      alias inspect to_s

      protected

      def load!
      end

      def split_version!
        @major, @minor, @patch = version.split('.',3).map { |s| s.to_i }
      end

      def build_version!
        @version = "#{@major}.#{@minor}.#{@patch}"
      end

    end
  end
end
