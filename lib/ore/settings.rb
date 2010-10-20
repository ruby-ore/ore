require 'ore/exceptions/invalid_metadata'
require 'ore/dependency'

require 'rubygems/version'

module Ore
  module Settings
    protected

    #
    # Sets the project files.
    #
    def set_project_files!
      @project_files = Set[]

      filter_path = lambda { |path|
        check_readable(path) { |file| @project_files << file }
      }

      within do
        case @scm
        when :git
          `git ls-files -z`.split("\0").each(&filter_path)
        else
          glob(&filter_path)
        end
      end
    end

    #
    # Sets the version of the project.
    #
    # @param [Hash<Integer>, String] version
    #   The version from the metadata file.
    #
    # @raise [InvalidVersion]
    #   The version must either be a `String` or a `Hash`.
    #
    def set_version!(version)
      case version
      when Hash
        numbers = [
          (version['major'] || 0),
          (version['minor'] || 0),
          (version['patch'] || 0),
          version['build']
        ]

        numbers << version['build'] if version['build']

        @version = Gem::Version.new(numbers.join('.'))
      when String
        @version = version
      else
        raise(InvalidMetadata,"version must be a Hash or a String")
      end
    end

    #
    # Sets the authors of the project.
    #
    # @param [Array<String>, String] authors
    #   The authors listed in the metadata file.
    #
    def set_authors!(authors)
      if authors.kind_of?(Array)
        @authors += authors
      else
        @authors << authors
      end
    end

    #
    # Sets the release date of the project.
    #
    # @param [String] date
    #   The release date from the metadata file.
    #
    def set_date!(date)
      @date = Date.parse(date)
    end

    #
    # Sets the require-paths of the project.
    #
    # @param [Array<String>, String] paths
    #   The require-paths or the glob-pattern listed in the metadata file.
    #
    def set_require_paths!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_require_path(path) }
      else
        glob(paths) { |path| add_require_path(path) }
      end
    end

    #
    # Sets the executables of the project.
    #
    # @param [Array<String>, String]
    #   The executable names or the glob-pattern listed in the metadata
    #   file.
    #   
    def set_executables!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_executable(path) }
      else
        glob(paths) { |path| add_executable(path) }
      end
    end

    #
    # Sets the default executable of the project.
    #
    # @param [String] name
    #   The default executable name listed in the metadata file.
    #
    def set_default_executable!(name)
      if @executables.include?(name)
        @default_executable = name
      else
        warn "#{name} is not in the executables list"
      end
    end

    #
    # Sets the extra-files of the project.
    #
    # @param [Array<String>, String] paths
    #   The extra-files or the glob-pattern listed in the metadata file.
    #
    def set_extra_files!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_extra_file(path) }
      else
        glob(paths) { |path| add_extra_file(path) }
      end
    end

    #
    # Sets the files of the project.
    #
    # @param [Array<String>, String] paths
    #   The files or the glob-pattern listed in the metadata file.
    #
    def set_files!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_file(path) }
      else
        glob(paths) { |path| add_file(path) }
      end
    end

    #
    # Sets the test-files of the project.
    #
    # @param [Array<String>, String] paths
    #   The test-files of the glob-pattern listed in the metadata file.
    #
    def set_test_files!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_test_file(path) }
      else
        glob(paths) { |path| add_test_file(path) }
      end
    end

    #
    # Sets the dependencies of the project.
    #
    # @param [Hash{String => String}, Array<String>] dependencies
    #   The dependencey names and versions listed in the metadata file.
    #
    # @raise [InvalidMetadata]
    #   The dependencies must either be a `Hash` or an `Array`.
    #
    def set_dependencies!(dependencies)
      case dependencies
      when Hash
        dependencies.each do |name,versions|
          @dependencies << Dependency.parse_versions(name,versions)
        end
      when Array
        dependencies.each do |dep|
          @dependencies << Dependency.parse(dep)
        end
      else
        raise(InvalidMetadata,"dependencies must be a Hash or Array")
      end
    end

    #
    # Sets the runtime-dependencies of the project.
    #
    # @param [Hash{String => String}, Array<String>] dependencies
    #   The runtime-dependencey names and versions listed in the metadata
    #   file.
    #
    # @raise [InvalidMetadata]
    #   The runtime-dependencies must either be a `Hash` or an `Array`.
    #
    def set_runtime_dependencies!(dependencies)
      case dependencies
      when Hash
        dependencies.each do |name,versions|
          @runtime_dependencies << Dependency.parse_versions(name,versions)
        end
      when Array
        dependencies.each do |dep|
          @runtime_dependencies << Dependency.parse(dep)
        end
      else
        raise(InvalidMetadata,"runtime_dependencies must be a Hash or Array")
      end
    end

    #
    # Sets the development-dependencies of the project.
    #
    # @param [Hash{String => String}, Array<String>] dependencies
    #   The development-dependencey names and versions listed in the
    #   metadata file.
    #
    # @raise [InvalidMetadata]
    #   The development-dependencies must either be a `Hash` or an `Array`.
    #
    def set_development_dependencies!(dependencies)
      case dependencies
      when Hash
        dependencies.each do |name,versions|
          @development_dependencies << Dependency.parse_versions(name,versions)
        end
      when Array
        dependencies.each do |dep|
          @development_dependencies << Dependency.parse(dep)
        end
      else
        raise(InvalidMetadata,"development_dependencies must be a Hash or Array")
      end
    end
  end
end
