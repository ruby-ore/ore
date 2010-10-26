require 'ore/naming'

module Ore
  #
  # A mixin for {Project} which provides methods for working with paths.
  #
  module Paths
    include Naming

    #
    # Builds a path relative to the project.
    #
    # @param [Array] names
    #   The directory names of the path.
    #
    # @return [Pathname]
    #   The new path.
    #
    def path(*names)
      @root.join(*names)
    end

    #
    # The `bin/` directory of the project.
    #
    # @return [Pathname]
    #   The path to the `bin/` directory.
    #
    def bin_dir
      @root.join(@@lib_dir)
    end

    #
    # The `lib/` directory of the project.
    #
    # @return [Pathname]
    #   The path to the `lib/` directory.
    #
    def lib_dir
      @root.join(@@lib_dir)
    end

    #
    # The `pkg/` directory of the project.
    #
    # @return [Pathname]
    #   The path to the `pkg/` directory.
    #
    def pkg_dir
      @root.join(@@pkg_dir)
    end

    #
    # Builds a path relative to the `lib/` directory.
    #
    # @param [Array] names
    #   The directory names of the path.
    #
    # @return [Pathname]
    #   The new path.
    #
    def lib_path(*names)
      path(@@lib_dir,*names)
    end

    #
    # Builds a relative path into the `pkg/` directory for the `.gem` file.
    #
    # @return [String]
    #   The path of a `.gem` file for the project.
    #
    def pkg_file
      File.join(@@pkg_dir,"#{@name}-#{@version}.gem")
    end

    #
    # Determines if a directory exists within the project.
    #
    # @param [String] path
    #   The path of the directory, relative to the project.
    #
    # @return [Boolean]
    #   Specifies whether the directory exists in the project.
    #
    def directory?(path)
      @root.join(path).directory?
    end

    #
    # Determines if a file exists within the project.
    #
    # @param [String] path
    #   The path of the file, relative to the project.
    #
    # @return [Boolean]
    #   Specifies whether the file exists in the project.
    #
    def file?(path)
      @project_files.include?(path)
    end

    #
    # Determines if a directory exists within the `lib/` directory of the
    # project.
    #
    # @return [Boolean]
    #   Specifies that the directory exists within the `lib/` directory.
    #
    def lib_directory?(path)
      directory?(File.join(@@lib_dir,path))
    end

    #
    # Determines if a file exists within the `lib/` directory of the
    # project.
    #
    # @return [Boolean]
    #   Specifies that the file exists within the `lib/` directory.
    #
    def lib_file?(path)
      file?(File.join(@@lib_dir,path))
    end

    #
    # Finds paths within the project that match a glob pattern.
    #
    # @param [String] pattern
    #   The glob pattern.
    #
    # @yield [path]
    #   The given block will be passed matching paths.
    #
    # @yieldparam [String] path
    #   A path relative to the root directory of the project.
    #
    def glob(pattern)
      within do
        Dir.glob(pattern) do |path|
          if (@project_files.include?(path) || File.directory?(path))
            yield path
          end
        end
      end
    end
  end
end
