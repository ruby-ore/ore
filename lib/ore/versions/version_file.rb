require 'ore/versions/version'

require 'yaml'

module Ore
  module Versions
    class VersionFile < Version

      FILES = %w[VERSION VERSION.yml]

      def self.find(root)
        FILES.each do |name|
          path = File.join(root,name)
          return self.load(path) if File.file?(path)
        end

        return nil
      end

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
