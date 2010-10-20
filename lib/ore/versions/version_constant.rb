require 'ore/versions/version'

module Ore
  module Versions
    class VersionConstant < Version

      FILE_NAME = 'version.rb'

      def self.find(root)
        project_name = File.basename(root)

        # check lib/project_name/version.rb
        path = File.join(root,'lib',project_name,FILE_NAME)
        return self.load(path) if File.file?(path)

        # split project_name by '-', check recursively
        names = project_name.split('-')

        (1..names.length).each do |n|
          path = File.join(root,'lib',*names[0..n],FILE_NAME)
          return self.load(path) if File.file?(path)
        end

        return nil
      end

      def self.load(path)
        major = nil
        minor = nil
        patch = nil
        build = nil

        File.open(path) do |file|
          file.each_line do |line|
            if line =~ /(VERSION|Version)\s*=\s*/
              return self.parse(extract_string(line))
            elsif line =~ /(MAJOR|Major)\s*=\s*/
              major ||= extract_number(line)
            elsif line =~ /(MINOR|Minor)\s*=\s*/
              minor ||= extract_number(line)
            elsif line =~ /(PATCH|Patch)\s*=\s*/
              patch ||= extract_number(line)
            elsif line =~ /(BUILD|Build)\s*=\s*/
              build ||= extract_number(line)
            end

            break if (major && minor && patch && build)
          end
        end

        return self.new(major,minor,patch,build)
      end

      protected

      def self.extract_string(line)
        if (match = line.match(/=\s*['"](\d+\.\d+\.\d+)['"]/))
          match[1]
        end
      end

      def self.extract_number(line)
        if (match = line.match(/=\s*['"]?(\d+)['"]?/))
          match[1].to_i
        end
      end

    end
  end
end
