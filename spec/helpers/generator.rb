require 'pathname'
require 'yaml'
require 'helpers/common'

module Helpers
  module Generator
    include Helpers::Common

    def generate!(path,options={})
      @path = from_root_path(path)

      @generator = Ore::Generator.new(
        [@path.to_s],
        options.merge(quiet: true)
      )
      @generator.invoke_all

      @gemspec = Dir.chdir(@path) do
        Gem::Specification.load(@generator.generated_files['[name].gemspec'])
      end
    end

    def rakefile
      @path.join('Rakefile').read
    end

    def rspec_opts
      @path.join('.rspec').read
    end

    def yard_opts
      @path.join('.yardopts').read
    end

    def document
      unless @document
        @document = []

        @path.join('.document').open do |file|
          file.each_line do |line|
            unless (line.empty? && line =~ /\s*\#/)
              @document << line.strip
            end
          end
        end
      end

      return @document
    end

    def gitignore
      unless @gitignore
        @gitignore = []

        @path.join('.gitignore').open do |file|
          file.each_line do |line|
            unless (line.empty? && line =~ /\s*\#/)
              @gitignore << line.strip
            end
          end
        end
      end

      return @gitignore
    end
  end
end
