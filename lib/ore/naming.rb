module Ore
  #
  # Provides methods for guessing the namespaces and directories
  # of projects. {Naming} uses the naming conventions of project names
  # defined by the
  # [Ruby Packaging Standard (RPS)](http://chneukirchen.github.com/rps/).
  #
  module Naming
    # The directory which contains executables for a project
    @@bin_dir = 'bin'

    # The directory which contains the code for a project
    @@lib_dir = 'lib'

    # The directory which contains C extension code for a project
    @@ext_dir = 'ext'

    # The directory which contains data files for a project
    @@data_dir = 'data'

    # The directory which contains unit-tests for a project
    @@test_dir = 'test'

    # The directory which contains spec-tests for a project
    @@spec_dir = 'spec'

    # The directory which contains built packages
    @@pkg_dir = 'pkg'

    # Common project prefixes and namespaces
    @@common_namespaces = {
      'ffi' => 'FFI',
      'dm' => 'DataMapper'
    }

    #
    # Guesses the module names from a project name.
    #
    # @return [Array<String>]
    #   The module names for a project.
    #
    def modules_of(name)
      name.split('-').map do |words|
        words.split('_').map { |word|
          @@common_namespaces[word] || word.capitalize
        }.join
      end
    end

    #
    # Guesses the full namespace for a project.
    #
    # @return [String]
    #   The full module namespace for a project.
    #
    def namespace_of(name)
      modules_of(name).join('::')
    end

    #
    # Converts a camel-case name to an underscored file name.
    #
    # @param [String] name
    #   The name to underscore.
    #
    # @return [String]
    #   The underscored version of the name.
    #
    def underscore(name)
      name.gsub(/[^A-Z_][A-Z][^A-Z_]/) { |cap|
        cap[0,1] + '_' + cap[1..-1]
      }.downcase
    end

    #
    # Guesses the namespace directories within `lib/` for a project.
    #
    # @return [Array<String>]
    #   The namespace directories for the project.
    #
    def namespace_dirs_of(name)
      name.split('-').map { |word| underscore(word) }
    end

    #
    # Guesses the namespace directory within `lib/` for a project.
    #
    # @return [String]
    #   The namespace directory for the project.
    #
    def namespace_path_of(name)
      File.join(namespace_dirs_of(name))
    end
  end
end
