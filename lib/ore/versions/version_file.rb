require 'ore/versions/version'

require 'yaml'

module Ore
  module Versions
    class VersionFile < Version

      FILES = %w[VERSION VERSION.yml]

      def self.find(root)
        FILES.each do |name|
          path = File.join(root,name)
          return self.new(path) if File.file?(path)
        end

        return nil
      end

      protected

      def load!
        data = YAML.load_file(@path)

        case data
        when Hash
          @major = (data[:major] || data['major'])
          @minor = (data[:minor] || data['minor'])
          @patch = (data[:patch] || data['patch'])

          build_version!
        when String
          @version = data

          split_version!
        else
          file = File.basename(@path)

          raise(InvalidVersion,"invalid version data in #{file.dump}")
        end
      end

    end
  end
end
