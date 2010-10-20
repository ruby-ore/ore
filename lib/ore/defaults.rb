module Ore
  module Defaults
    DEFAULT_REQUIRE_PATHS = %w[lib ext]

    DEFAULT_EXECUTABLES = 'bin/*'

    DEFAULT_TEST_FILES = %w[
      test/{**/}*_test.rb
      spec/{**/}*_spec.rb}
    ]

    DEFAULT_EXCLUDE_FILES = %w[
      .gitignore
    ]

    protected

    def default_name!
      @name = @root.basename.to_s
    end

    def default_version!
      @version = (
        Versions::VersionFile.find(@root) ||
        Versions::VersionConstant.find(@root)
      )

      unless @version
        raise(InvalidMetadata,"could not find a version file or constant")
      end
    end

    def default_date!
      @date = Date.today
    end

    def default_require_paths!
      DEFAULT_REQUIRE_PATHS.each do |name|
        @require_paths << name if @root.join(name).directory?
      end
    end

    def default_executables!
      glob(DEFAULT_EXECUTABLES) do |path|
        check_executable(path) { |exe| @executables << File.basename(exe) }
      end
    end

    def default_executable!
      @executable = if @executables.include?(@name)
                      @name
                    else
                      @executables.first
                    end
    end

    def default_extra_files!
      if @document
        @document.extra_files.each { |path| add_extra_file(path) }
      end
    end

    def default_files!
      @project_files.each do |file|
        @files << file unless DEFAULT_EXCLUDE_FILES.include?(file)
      end
    end

    def default_test_files!
      DEFAULT_TEST_FILES.each do |pattern|
        glob(pattern) { |path| add_test_file(path) }
      end
    end

  end
end
