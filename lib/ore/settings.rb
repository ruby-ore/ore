require 'ore/exceptions/invalid_metadata'
require 'ore/versions/version'
require 'ore/dependency'

module Ore
  module Settings
    protected

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
        major = version['major']
        minor = version['minor']
        patch = version['patch']
        build = version['build']

        @version = Versions::Version.new(major,minor,patch,build)
      when String
        @version = Versions::Version.parse(version)
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
    # Sets the extra documentation files of the project.
    #
    # @param [Array<String>, String] paths
    #   The file paths or the glob-pattern listed in the metadata file.
    #
    def set_extra_doc_files!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_extra_doc_file(path) }
      else
        glob(paths) { |path| add_extra_doc_file(path) }
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
    # Sets the Ruby version required by the project.
    #
    # @param [String] version
    #   The version requirement.
    #
    def set_required_ruby_version!(version)
      @required_ruby_version = version.to_s
    end

    #
    # Sets the RubyGems version required by the project.
    #
    # @param [String] version
    #   The version requirement.
    #
    def set_required_rubygems_version!(version)
      @required_rubygems_version = version.to_s
    end

    #
    # Sets the dependencies of the project.
    #
    # @param [Hash{String => String}] dependencies
    #   The dependencey names and versions listed in the metadata file.
    #
    # @raise [InvalidMetadata]
    #   The dependencies must be a `Hash`.
    #
    def set_dependencies!(dependencies)
      unless dependencies.kind_of?(Hash)
        raise(InvalidMetadata,"dependencies must be a Hash")
      end

      dependencies.each do |name,versions|
        @dependencies << Dependency.parse_versions(name,versions)
      end
    end

    #
    # Sets the runtime-dependencies of the project.
    #
    # @param [Hash{String => String}] dependencies
    #   The runtime-dependencey names and versions listed in the metadata
    #   file.
    #
    # @raise [InvalidMetadata]
    #   The runtime-dependencies must be a `Hash`.
    #
    def set_runtime_dependencies!(dependencies)
      unless dependencies.kind_of?(Hash)
        raise(InvalidMetadata,"runtime_dependencies must be a Hash")
      end

      dependencies.each do |name,versions|
        @runtime_dependencies << Dependency.parse_versions(name,versions)
      end
    end

    #
    # Sets the development-dependencies of the project.
    #
    # @param [Hash{String => String}] dependencies
    #   The development-dependencey names and versions listed in the
    #   metadata file.
    #
    # @raise [InvalidMetadata]
    #   The development-dependencies must be a `Hash`.
    #
    def set_development_dependencies!(dependencies)
      unless dependencies.kind_of?(Hash)
        raise(InvalidMetadata,"development_dependencies must be a Hash")
      end

      dependencies.each do |name,versions|
        @development_dependencies << Dependency.parse_versions(name,versions)
      end
    end
  end
end
