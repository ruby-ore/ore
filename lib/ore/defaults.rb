require 'ore/directories'
require 'ore/versions'

require 'date'

module Ore
  module Defaults
    include Directories

    # The default require-paths
    DEFAULT_REQUIRE_PATHS = [LIB_DIR, EXT_DIR]

    # The glob to find default executables
    DEFAULT_EXECUTABLES = "#{BIN_DIR}/*"

    # The globs to find all testing-files
    DEFAULT_TEST_FILES = [
      "#{TEST_DIR}/{**/}*_test.rb",
      "#{SPEC_DIR}/{**/}*_spec.rb"
    ]

    # The files to always exclude
    DEFAULT_EXCLUDE_FILES = %w[
      .gitignore
    ]

    protected

    #
    # Sets the project name using the directory name of the project.
    #
    def default_name!
      @name = @root.basename.to_s
    end

    #
    # Finds and sets the version of the project.
    #
    def default_version!
      @version = (
        Versions::VersionFile.find(self) ||
        Versions::VersionConstant.find(self)
      )

      unless @version
        raise(InvalidMetadata,"no version file or constant in #{@root}")
      end
    end

    #
    # Sets the release date of the project.
    #
    def default_date!
      @date = Date.today
    end

    #
    # Sets the require-paths of the project.
    #
    def default_require_paths!
      DEFAULT_REQUIRE_PATHS.each do |name|
        @require_paths << name if @root.join(name).directory?
      end
    end

    #
    # Sets the executables of the project.
    #
    def default_executables!
      glob(DEFAULT_EXECUTABLES) do |path|
        check_executable(path) { |exe| @executables << File.basename(exe) }
      end
    end

    #
    # sets the default executable of the project.
    #
    def default_executable!
      @default_executable = if @executables.include?(@name)
                              @name
                            else
                              @executables.first
                            end
    end

    #
    # Sets the default documentation of the project.
    #
    def default_documentation!
      if file?('.yardopts')
        @documentation = :yard
      else
        @documentation = :rdoc
      end
    end

    #
    # Sets the extra-files of the project.
    #
    def default_extra_files!
      glob('README.*') { |path| add_extra_file(path) }

      if @document
        @document.each_extra_file { |path| add_extra_file(path) }
      end
    end

    #
    # Sets the files of the project.
    #
    def default_files!
      @project_files.each do |file|
        @files << file unless DEFAULT_EXCLUDE_FILES.include?(file)
      end
    end

    #
    # Sets the test-files of the project.
    #
    def default_test_files!
      DEFAULT_TEST_FILES.each do |pattern|
        glob(pattern) { |path| add_test_file(path) }
      end
    end

  end
end
