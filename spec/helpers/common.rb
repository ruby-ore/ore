require 'pathname'
require 'tempfile'
require 'shell'

module Helpers
  module Common
    ROOT = Pathname.new(Dir.tmpdir).join('ore')

    def from_root_path(path)
      ROOT.join(path)
    end

    def have_git?
      @have_git ||= !!Shell.new.find_system_command('git')
    rescue Shell::Error::CommandNotFound
      @have_git = false
    end

    def cleanup!
      ROOT.rmtree
    end
  end
end
