require 'ore/versions/exceptions/invalid_version'
require 'ore/versions/version'

require 'yaml'

module Ore
  module Versions
    #
    # Represents a version loaded from a `VERSION` file.
    #
    class VersionFile < Version

      # Common `VERSION` file-names.
      FILES = %w[VERSION VERSION.yml]

      #
      # Finds the `VERSION` file.
      #
      # @param [String] root
      #   The root directory of the project.
      #
      # @return [VersionFile, nil]
      #   The version file of the project.
      #
      def self.find(root)
        FILES.each do |name|
          path = File.join(root,name)
          return self.load(path) if File.file?(path)
        end

        return nil
      end

      #
      # Loads the version file of the project.
      #
      # @param [String] path
      #   The path to the version file.
      #
      # @return [VersionFile]
      #   The loaded version file.
      #
      # @raise [InvalidVersion]
      #   The `VERSION` file must contain either a `Hash` or a `String`.
      #
      def self.load(path)
        data = YAML.load_file(path)

        case data
        when Hash
          self.new(
            (data[:major] || data['major']),
            (data[:minor] || data['minor']),
            (data[:patch] || data['patch']),
            (data[:build] || data['build'])
          )
        when String
          self.parse(data)
        else
          file = File.basename(@path)
          raise(InvalidVersion,"invalid version data in #{file.dump}")
        end
      end

    end
  end
end
