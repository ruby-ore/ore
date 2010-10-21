require 'ore/versions/version'
require 'ore/directories'

module Ore
  module Versions
    #
    # Represents a version loaded from a Ruby `VERSION` constant or
    # `Version` module.
    #
    class VersionConstant < Version

      include Directories

      # Common file-name that the `VERSION` constant or `Version` module
      # is defined within.
      FILE_NAME = 'version.rb'

      #
      # Finds the `version.rb` file.
      #
      # @param [String] root
      #   The root directory of the project.
      #
      # @return [VersionConstant, nil]
      #   The loaded version constant.
      #
      def self.find(root)
        version_paths = Dir[File.join(root,LIB_DIR,'**','version.rb')]
        path = version_paths.sort.first

        return self.load(path) if File.file?(path)
      end

      #
      # Extracts the `VERSION` constant or the major / minor / patch / build
      # version numbers from the `Version` module.
      #
      # @param [String] path
      #   The path to the `version.rb` file.
      #
      # @return [VersionConstant, nil]
      #   The loaded version constant.
      #
      def self.load(path)
        major = nil
        minor = nil
        patch = nil
        build = nil

        File.open(path) do |file|
          file.each_line do |line|
            unless line =~ /^\s*#/ # skip commented lines
              if line =~ /(VERSION|Version)\s*=\s*/
                return self.parse(extract_version(line))
              elsif line =~ /(MAJOR|Major)\s*=\s*/
                major ||= extract_number(line)
              elsif line =~ /(MINOR|Minor)\s*=\s*/
                minor ||= extract_number(line)
              elsif line =~ /(PATCH|Patch)\s*=\s*/
                patch ||= extract_number(line)
              elsif line =~ /(BUILD|Build)\s*=\s*/
                build ||= extract_string(line)
              end

              break if (major && minor && patch && build)
            end
          end
        end

        return self.new(major,minor,patch,build)
      end

      protected

      #
      # Extracts the version string from a `VERSION` constant declaration.
      #
      # @param [String] line
      #   The line of Ruby code where the `VERSION` constant was defined.
      #
      # @return [String, nil]
      #   The extracted version string.
      #
      def self.extract_version(line)
        if (match = line.match(/=\s*['"](\d+\.\d+\.\d+(\.\w+)?)['"]/))
          match[1]
        end
      end

      #
      # Extracts a number from a `BUILD` constant declaration.
      #
      # @param [String] line
      #   The line of Ruby code where the constant was defined.
      #
      # @return [String, nil]
      #   The extracted string.
      #
      def self.extract_string(line)
        if (match = line.match(/=\s*['"]?(\w+)['"]?/))
          match[1]
        end
      end

      #
      # Extracts a version number from a `MAJOR`, `MINOR`, `PATCH` or
      # `BUILD` constant declaration.
      #
      # @param [String] line
      #   The line of Ruby code where the constant was defined.
      #
      # @return [Integer, nil]
      #   The extracted version number.
      #
      def self.extract_number(line)
        if (match = line.match(/=\s*['"]?(\d+)['"]?/))
          match[1].to_i
        end
      end

    end
  end
end
