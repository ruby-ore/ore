require 'tempfile'
require 'pathname'
require 'yaml'
require 'fileutils'

module Helpers
  module Generator
    ROOT = File.join(Dir.tmpdir,'ore')

    def generate!(path,options={})
      path = File.join(ROOT,path)

      @generator = Ore::Generator.new(
        [path],
        options.merge(:quiet => true)
      )
      @generator.invoke_all

      @path    = Pathname.new(path)
      @gemspec = Dir.chdir(@path) do
        Gem::Specification.load(@generator.generated_files['[name].gemspec'])
      end
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

    def cleanup!
      FileUtils.rm_r(ROOT)
    end
  end
end
