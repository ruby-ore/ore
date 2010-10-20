module Ore
  module Checks
    protected

    def check_readable(path)
      if File.readable?(path)
        yield path
      else
        warn "#{path} is not readable!"
      end
    end

    def check_directory(path)
      check_readable(path) do |dir|
        if File.directory?(dir)
          yield dir
        else
          warn "#{dir} is not a directory!"
        end
      end
    end

    def check_file(path)
      check_readable(path) do |file|
        if File.file?(file)
          yield file
        else
          warn "#{file} is not a file!"
        end
      end
    end

    def check_executable(path)
      check_file(path) do |file|
        if File.executable?(file)
          yield file
        else
          warn "#{file} is not executable!"
        end
      end
    end
  end
end
