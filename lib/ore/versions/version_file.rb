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
      @@files = %w[VERSION VERSION.yml]

      #
      # Finds the `VERSION` file.
      #
      # @param [Project] project
      #   The Ore project.
      #
      # @return [VersionFile, nil]
      #   The version file of the project.
      #
      def self.find(project)
        @@files.each do |name|
          return load(project.path(name)) if project.file?(name)
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
