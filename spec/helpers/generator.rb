require 'tempfile'
require 'pathname'
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

      return Pathname.new(path)
    end

    def cleanup!
      FileUtils.rm_r(ROOT)
    end
  end
end
