require 'ore/naming'
require 'ore/versions'

require 'date'

module Ore
  #
  # A mixin for {Project} which provides methods for assigning default
  # values to project attributes.
  #
  module Defaults
    include Naming

    # The default require-paths
    @@require_paths = [@@lib_dir, @@ext_dir]

    # The glob to find default executables
    @@executables = "#{@@bin_dir}/*"

    # The globs to find all testing-files
    @@test_files = [
      "#{@@test_dir}/{**/}*_test.rb",
      "#{@@spec_dir}/{**/}*_spec.rb"
    ]

    # The files to always exclude
    @@exclude_files = %w[
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
      @@require_paths.each do |name|
        @require_paths << name if @root.join(name).directory?
      end
    end

    #
    # Sets the executables of the project.
    #
    def default_executables!
      glob(@@executables) do |path|
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
    # Sets the extra documentation files of the project.
    #
    def default_extra_doc_files!
      glob('README.*') { |path| add_extra_doc_file(path) }

      if @document
        @document.each_extra_file { |path| add_extra_doc_file(path) }
      end
    end

    #
    # Sets the files of the project.
    #
    def default_files!
      @project_files.each do |file|
        @files << file unless @@exclude_files.include?(file)
      end
    end

    #
    # Sets the test-files of the project.
    #
    def default_test_files!
      @@test_files.each do |pattern|
        glob(pattern) { |path| add_test_file(path) }
      end
    end

    #
    # Defaults the required version of RubyGems to `>= 1.3.6`, if the
    # project uses Bundler.
    #
    def default_required_rubygems_version!
      if bundler?
        @required_rubygems_version = '>= 1.3.6'
      end
    end

  end
end
