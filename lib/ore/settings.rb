require 'rubygems/version'

module Ore
  module Settings
    protected

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

    def set_authors!(authors)
      if authors.kind_of?(Array)
        @authors += authors
      else
        @authors << authors
      end
    end

    def set_date!(date)
      @date = Date.parse(date)
    end

    def set_require_paths!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_require_path(path) }
      else
        glob(paths) { |path| add_require_path(path) }
      end
    end

    def set_executables!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_executable(path) }
      else
        glob(paths) { |path| add_executable(path) }
      end
    end

    def set_executable!(path)
      @executable = metadata['executable']
      @executables << @executable
    end

    def set_extra_files!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_extra_file(path) }
      else
        glob(paths) { |path| add_extra_file(path) }
      end
    end

    def set_files!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_file(path) }
      else
        glob(paths) { |path| add_file(path) }
      end
    end

    def set_test_files!(paths)
      if paths.kind_of?(Array)
        paths.each { |path| add_test_file(path) }
      else
        glob(paths) { |path| add_test_file(path) }
      end
    end

    def set_dependencies!(dependencies)
      case dependencies
      when Hash
        dependencies.each do |name,version|
          @dependencies[name] = version
        end
      when Array
        dependencies.each do |dep|
          name, version = split_dependencey(dep)

          @dependencies[name] = version
        end
      else
        raise(InvalidMetadata,"dependencies must be a Hash or Array")
      end
    end

    def set_runtime_dependencies!(dependencies)
      case dependencies
      when Hash
        dependencies.each do |name,version|
          @runtime_dependencies[name] = version
        end
      when Array
        dependencies.each do |dep|
          name, version = split_dependencey(dep)

          @runtime_dependencies[name] = version
        end
      else
        raise(InvalidMetadata,"runtime_dependencies must be a Hash or Array")
      end
    end

    def set_development_dependencies!(dependencies)
      case dependencies
      when Hash
        dependencies.each do |name,version|
          @development_dependencies[name] = version
        end
      when Array
        dependencies.each do |dep|
          name, version = split_dependencey(dep)

          @development_dependencies[name] = version
        end
      else
        raise(InvalidMetadata,"development_dependencies must be a Hash or Array")
      end
    end

  end
end
