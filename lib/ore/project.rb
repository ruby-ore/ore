require 'ore/exceptions/project_not_found'
require 'ore/exceptions/invalid_metadata'
require 'ore/directories'
require 'ore/document_file'
require 'ore/checks'
require 'ore/defaults'
require 'ore/settings'

require 'pathname'
require 'yaml'
require 'set'
require 'fileutils'

module Ore
  class Project

    include Directories
    include Checks
    include Defaults
    include Settings

    # The project metadata file
    METADATA_FILE = 'gem.yml'

    # The SCM which the project is currently under
    attr_reader :scm

    # The files of the project
    attr_reader :project_files

    # The name of the project
    attr_reader :name

    # The version of the project
    attr_reader :version

    # The project summary
    attr_reader :summary

    # The project description
    attr_reader :description

    # The authors of the project
    attr_reader :authors

    # The homepage for the project
    attr_reader :homepage

    # The email contact for the project
    attr_reader :email

    # The build date for any project gems
    attr_reader :date

    # The parsed `.document` file
    attr_reader :document

    # The directories to search within the project when requiring files
    attr_reader :require_paths

    # The names of the executable scripts
    attr_reader :executables

    # The default executable
    attr_reader :default_executable

    # Any extra files to include in the project documentation
    attr_reader :extra_files

    # The files of the project
    attr_reader :files

    # The test files for the project
    attr_reader :test_files

    # The dependencies of the project
    attr_reader :dependencies

    # The runtime-dependencies of the project
    attr_reader :runtime_dependencies

    # The development-dependencies of the project
    attr_reader :development_dependencies

    #
    # Creates a new {Project}.
    #
    # @param [String] root
    #   The root directory of the project.
    #
    def initialize(root)
      @root = Pathname.new(root).expand_path

      unless @root.directory?
        raise(ProjectNotFound,"#{@root} is not a directory")
      end

      infer_scm!
      set_project_files!

      metadata_file = @root.join(METADATA_FILE)

      unless metadata_file.file?
        raise(ProjectNotFound,"#{@root} does not contain #{METADATA_FILE}")
      end

      metadata = YAML.load_file(metadata_file)

      unless metadata.kind_of?(Hash)
        raise(InvalidMetadata,"#{metadata_file} did not contain valid metadata")
      end

      if metadata['name']
        @name = metadata['name'].to_s
      else
        default_name!
      end

      if metadata['version']
        set_version! metadata['version']
      else
        default_version!
      end

      @summary = (metadata['summary'] || metadata['description'])
      @description = (metadata['description'] || metadata['summary'])

      @authors = Set[]

      if metadata['authors']
        set_authors! metadata['authors']
      end

      @homepage = metadata['homepage']
      @email = metadata['email']

      if metadata['date']
        set_date! metadata['date']
      else
        default_date!
      end

      document_path = @root.join(DocumentFile::NAME)

      if document_path.file?
        @document = DocumentFile.new(document_path)
      end

      @require_paths = Set[]

      if metadata['require_paths']
        set_require_paths! metadata['require_paths']
      else
        default_require_paths!
      end

      @executables = Set[]

      if metadata['executables']
        set_executables! metadata['executables']
      else
        default_executables!
      end

      @default_executable = nil

      if metadata['default_executable']
        set_default_executable! metadata['default_executable']
      else
        default_executable!
      end

      @extra_files = Set[]

      if metadata['extra_files']
        set_extra_files! metadata['extra_files']
      else
        default_extra_files!
      end

      @files = Set[]

      if metadata['files']
        set_files! metadata['files']
      else
        default_files!
      end

      @test_files = Set[]

      if metadata['test_files']
        set_test_files! metadata['test_files']
      else
        default_test_files!
      end

      @dependencies = Set[]

      if metadata['dependencies']
        set_dependencies! metadata['dependencies']
      end

      @runtime_dependencies = Set[]

      if metadata['runtime_dependencies']
        set_runtime_dependencies! metadata['runtime_dependencies']
      end

      @development_dependencies = Set[]

      if metadata['development_dependencies']
        set_development_dependencies! metadata['development_dependencies']
      end
    end

    #
    # Finds the project metadata file and creates a new {Project} object.
    #
    # @param [String] dir (Dir.pwd)
    #   The directory to start searching upward from.
    #
    # @return [Project]
    #   The found project.
    #
    # @raise [ProjectNotFound]
    #   No project metadata file could be found.
    #
    def self.find(dir=Dir.pwd)
      Pathname.new(dir).ascend do |root|
        return self.new(root) if root.join(METADATA_FILE).file?
      end

      raise(ProjectNotFound,"could not find #{METADATA_FILE}")
    end

    #
    # Executes code within the project.
    #
    # @param [String] sub_dir
    #   An optional sub-directory within the project to execute from.
    #
    # @yield []
    #   The given block will be called once the current working-directory
    #   has been switched. Once the block finishes executing, the current
    #   working-directory will be switched back.
    #
    # @see http://ruby-doc.org/core/classes/Dir.html#M002314
    #
    def within(sub_dir=nil,&block)
      dir = if sub_dir
              @root.join(sub_dir)
            else
              @root
            end

      Dir.chdir(dir,&block)
    end

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
    # Builds a path relative to the `lib/` directory.
    #
    # @param [Array] names
    #   The directory names of the path.
    #
    # @return [Pathname]
    #   The new path.
    #
    def lib_path(*names)
      path(LIB_DIR,*names)
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

    #
    # Populates a Gem Specification using the metadata of the project.
    #
    # @yield [gemspec]
    #   The given block will be passed the populated Gem Specification
    #   object.
    #
    # @yieldparam [Gem::Specification] gemspec
    #   The newly created Gem Specification.
    #
    # @return [Gem::Specification]
    #   The Gem Specification.
    #
    # @see http://rubygems.rubyforge.org/rdoc/Gem/Specification.html
    #
    def to_gemspec
      gemspec = Gem::Specification.new()

      gemspec.name = @name.to_s
      gemspec.version = @version.to_s
      gemspec.summary = @summary.to_s
      gemspec.description = @description.to_s
      gemspec.authors += @authors.to_a
      gemspec.homepage = @homepage
      gemspec.email = @email
      gemspec.date = @date

      @require_paths.each do |path|
        unless gemspec.require_paths.include?(path)
          gemspec.require_paths << path
        end
      end

      gemspec.executables += @executables.to_a
      gemspec.default_executable = @default_executable
      gemspec.extra_rdoc_files += @extra_files.to_a
      gemspec.files += @files.to_a
      gemspec.test_files += @test_files.to_a

      @dependencies.each do |dep|
        gemspec.add_dependency(dep.name,*dep.versions)
      end

      @runtime_dependencies.each do |dep|
        gemspec.add_runtime_dependency(dep.name,*dep.versions)
      end

      @development_dependencies.each do |dep|
        gemspec.add_development_dependency(dep.name,*dep.versions)
      end

      yield gemspec if block_given?
      return gemspec
    end

    #
    # Builds a gem for the project.
    #
    # @return [Pathname]
    #   The path to the built gem file within the `pkg/` directory.
    #
    def build!
      pkg_dir = @root.join(PKG_DIR)
      FileUtils.mkdir_p(pkg_dir)

      gem_file = Gem::Builder.new(self.to_gemspec).build
      pkg_file = pkg_dir.join(gem_file)

      FileUtils.mv(gem_file,pkg_file)
      return pkg_file
    end

    protected

    #
    # Prints multiple warning messages.
    #
    # @param [Array] messages
    #   The messages to print.
    #
    def warn(*messages)
      messages.each { |mesg| STDERR.puts("WARNING: #{mesg}") }
    end

    #
    # Infers the Source Code Management used by the project.
    #
    def infer_scm!
      if @root.join('.git').directory?
        @scm = :git
      else
        @scm = nil
      end
    end

    #
    # Adds a require-path to the project.
    #
    # @param [String] path
    #   A directory path relative to the project.
    #
    def add_require_path(path)
      check_directory(path) { |dir| @require_paths << dir }
    end

    #
    # Adds an executable to the project.
    #
    # @param [String] name
    #   The name of the executable.
    #
    def add_executable(name)
      path = File.join(BIN_DIR,name)

      check_executable(path) { |exe| @executables << exe }
    end

    #
    # Adds an extra-file to the project.
    #
    # @param [String] path
    #   The path to the file, relative to the project.
    #
    def add_extra_file(path)
      check_file(path) { |file| @extra_files << file }
    end

    #
    # Adds a file to the project.
    #
    # @param [String] path
    #   The path to the file, relative to the project.
    #
    def add_file(path)
      check_file(path) { |file| @files << file }
    end

    #
    # Adds a testing-file to the project.
    #
    # @param [String] path
    #   The path to the testing-file, relative to the project.
    #
    def add_test_file(path)
      check_file(path) { |file| @test_files << file }
    end

  end
end
