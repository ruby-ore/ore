module Ore
  module Checks
    protected

    #
    # Checks if the path is readable.
    #
    # @yield [path]
    #   The block will be passed the path, if it is readable.
    #   Otherwise a warning will be printed.
    #
    # @yieldparam [String] path
    #   A readable path.
    #
    def check_readable(path)
      if File.readable?(path)
        yield path
      else
        warn "#{path} is not readable!"
      end
    end

    #
    # Checks if the path is a readable directory.
    #
    # @yield [path]
    #   The block will be passed the path, if it is a readable directory.
    #   Otherwise a warning will be printed.
    #
    # @yieldparam [String] path
    #   The directory path.
    #
    def check_directory(path)
      check_readable(path) do |dir|
        if File.directory?(dir)
          yield dir
        else
          warn "#{dir} is not a directory!"
        end
      end
    end

    #
    # Checks if the path is a readable file.
    #
    # @yield [path]
    #   The block will be passed the path, if it is a readable file.
    #   Otherwise a warning will be printed.
    #
    # @yieldparam [String] path
    #   A file path.
    #
    def check_file(path)
      check_readable(path) do |file|
        if File.file?(file)
          yield file
        else
          warn "#{file} is not a file!"
        end
      end
    end

    #
    # Checks if the path is an executable file.
    #
    # @yield [path]
    #   The block will be passed the path, if it is an executable file.
    #   Otherwise a warning will be printed.
    #
    # @yieldparam [String] path
    #   An path to an executable file.
    #
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
