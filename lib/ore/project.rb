require 'ore/exceptions/project_not_found'
require 'ore/exceptions/invalid_metadata'
require 'ore/document_file'
require 'ore/defaults'
require 'ore/settings'
require 'ore/versions'

require 'pathname'
require 'yaml'
require 'set'
require 'date'
require 'rubygems'

module Ore
  class Project

    include Defaults
    include Settings

    METADATA_FILE = 'gem.yml'

    attr_reader :scm

    attr_reader :project_files

    attr_reader :name

    attr_reader :version

    attr_reader :summary

    attr_reader :description

    attr_reader :authors

    attr_reader :homepage

    attr_reader :email

    attr_reader :date

    attr_reader :document

    attr_reader :require_paths

    attr_reader :executables

    attr_reader :extra_files

    attr_reader :files

    attr_reader :test_files

    attr_reader :dependencies

    attr_reader :runtime_dependencies

    attr_reader :development_dependencies

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

      @dependencies = {}

      if metadata['dependencies']
        set_dependencies! metadata['dependencies']
      end

      @runtime_dependencies = {}

      if metadata['runtime_dependencies']
        set_runtime_dependencies! metadata['runtime_dependencies']
      end

      @development_dependencies = {}

      if metadata['development_dependencies']
        set_development_dependencies! metadata['development_dependencies']
      end
    end

    def self.find(dir=Dir.pwd)
      Pathname.new(dir).ascend do |root|
        return self.new(root) if root.join(METADATA_FILE).file?
      end

      raise(ProjectNotFound,"could not find #{METADATA_FILE}")
    end

    def within(&block)
      Dir.chdir(@root,&block)
    end

    def glob(pattern,&block)
      within { Dir.glob(pattern,&block) }
    end

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
      gemspec.extra_rdoc_files += @extra_files.to_a
      gemspec.files += @files.to_a
      gemspec.test_files += @test_files.to_a

      @dependencies.each do |name,version|
        gemspec.add_dependencey(name,version)
      end

      @runtime_dependencies.each do |name,version|
        gemspec.add_runtime_dependencey(name,version)
      end

      @development_dependencies.each do |name,version|
        gemspec.add_development_dependencey(name,version)
      end

      yield gemspec if block_given?
      return gemspec
    end

    def build!
      Gem::Builder.new(self.to_gemspec).build
    end

    protected

    def warn(*messages)
      STDERR.puts(*messages)
    end

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

    def infer_scm!
      if @root.join('.git').directory?
        @scm = :git
      else
        @scm = nil
      end
    end

    def add_require_path(path)
      check_directory(path) { |dir| @require_paths << dir }
    end

    def add_executable(path)
      check_executable(path) { |exe| @executables << exe }
    end

    def add_extra_file(path)
      check_file(path) { |file| @extra_files << file }
    end

    def add_file(path)
      check_file(path) { |file| @files << file }
    end

    def add_test_file(path)
      check_file(path) { |file| @test_files << test_file }
    end

    def split_dependencey(dep)
      dep.split(' ',2)
    end

  end
end
