require 'tempfile'
require 'pathname'
require 'yaml'
require 'fileutils'

module Helpers
  module Generator
    ROOT = File.join(Dir.tmpdir,'ore')

    def generate!(path,options={})
      path = File.join(ROOT,path)

      Ore::Generator.new(
        [path],
        options.merge(:quiet => true)
      ).invoke_all

      @path = Pathname.new(path)
      @gemspec = YAML.load_file(@path.join('gemspec.yml'))
    end

    def rspec_opts
      @path.join('.rspec').read
    end

    def yard_opts
      @path.join('.yardopts').read
    end

    def cleanup!
      FileUtils.rm_r(ROOT)
    end
  end
end
