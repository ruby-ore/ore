require 'ore/versions/version'

module Ore
  module Versions
    class VersionConstant < Version

      FILE_NAME = 'version.rb'

      def self.find(root)
        project_name = File.basename(root)

        # check lib/project_name/version.rb
        path = File.join(root,'lib',project_name,FILE_NAME)
        return self.new(path) if File.file?(path)

        # split project_name by '-', check recursively
        names = project_name.split('-')

        (1..names.length).each do |n|
          path = File.join(root,'lib',*names[0..n],FILE_NAME)
          return self.new(path) if File.file?(path)
        end

        return nil
      end

      protected

      def extract_version!(line)
        if (match = line.match(/=\s*['"](\d+\.\d+\.\d+)['"]/))
          @version ||= match[1]
        end
      end

      def extract_num(line)
        if (match = line.match(/=\s*['"]?(\d+)['"]?/))
          match[1].to_i
        end
      end

      def extract_major!(line)
        @major ||= extract_num(line)
      end

      def extract_minor!(line)
        @minor ||= extract_num(line)
      end

      def extract_patch!(line)
        @patch ||= extract_num(line)
      end

      def load!
        File.open(@path) do |file|
          file.each_line do |line|
            if line =~ /(VERSION|Version)\s*=\s*/
              extract_version!(line)

              split_version!
              break
            elsif line =~ /(MAJOR|Major)\s*=\s*/
              extract_major!(line)
            elsif line =~ /(MINOR|Minor)\s*=\s*/
              extract_minor!(line)
            elsif line =~ /(PATCH|Patch)\s*=\s*/
              extract_patch!(line)
            end

            if (@major && @minor && @patch)
              build_version!
              break
            end
          end
        end
      end

    end
  end
end
