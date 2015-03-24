require 'ore/template/exceptions/invalid_template'

require 'yaml'
require 'find'

module Ore
  module Template
    #
    # Represents a template directory and the static files, `.erb` files
    # and sub-directories within it.
    #
    class Directory

      # The template configuration file
      CONFIG_FILE = 'template.yml'

      # Files or directory names to ignore
      IGNORE = ['.git', CONFIG_FILE]

      # The known markup languages and file extensions
      MARKUPS = {
        :markdown => %w[.md .markdown],
        :textile  => %w[.tt .textile],
        :rdoc     => %w[.rdoc]
      }

      # The path of the template directory
      attr_reader :path

      # The directories within the template directory
      attr_reader :directories

      # The static files in the template directory
      attr_reader :files

      # The ERb templates in the template directory
      attr_reader :templates

      # The include templates in the template directory
      attr_reader :includes

      # Other templates to be disabled
      attr_reader :disable

      # Other templates to be enabled
      attr_reader :enable

      # The variables to use when rendering the template files
      attr_reader :variables

      # Files to ignore
      #
      # @since 0.9.0
      attr_reader :ignore

      # Runtime dependencies defined by the template
      #
      # @since 0.9.0
      attr_reader :dependencies

      # Development dependencies defined by the template
      #
      # @since 0.9.0
      attr_reader :development_dependencies

      #
      # Initializes a new template directory.
      #
      # @param [String] path
      #   The path to the template directory.
      #
      def initialize(path)
        @path = File.expand_path(path)

        @directories = []
        @files       = {}
        @templates   = {}
        @includes    = Hash.new { |hash,key| hash[key] = {} }

        @disable = []
        @enable  = []

        @ignore                   = []
        @dependencies             = {}
        @development_dependencies = {}
        @variables                = {}

        load!
        scan!
      end

      #
      # Enumerates through the directories in the template directory.
      #
      # @yield [path]
      #   The given block will be passed each directory path.
      #
      # @yieldparam [String] path
      #   The relative path of a directory within the template directory.
      #
      def each_directory(&block)
        @directories.each(&block)
      end

      #
      # Enumerates through every file in the template directory.
      #
      # @param [Symbol] markup
      #   The markup to look for.
      #
      # @yield [path]
      #   The given block will be passed each file path.
      #
      # @yieldparam [String] path
      #   A relative path of a file within the template directory.
      #
      def each_file(markup)
        @files.each do |dest,file|
          if (formatted_like?(dest,markup) || !formatted?(dest))
            yield dest, file
          end
        end
      end

      #
      # Enumerates over every template within the template directory.
      #
      # @param [Symbol] markup
      #   The markup to look for.
      #
      # @yield [path]
      #   The given block will be passed each template path.
      #
      # @yieldparam [String] path
      #   A relative path of a template within the template directory.
      #
      def each_template(markup)
        @templates.each do |dest,file|
          if (formatted_like?(dest,markup) || !formatted?(dest))
            yield dest, file
          end
        end
      end

      protected

      #
      # Loads template configuration information from `template.yml`.
      #
      # @raise [InvalidTemplate]
      #   The `template.yml` file did not contain a YAML Hash.
      #
      # @since 0.2.0
      #
      def load!
        config_path = File.join(@path,CONFIG_FILE)
        return false unless File.file?(config_path)

        config = YAML.load_file(config_path)
        return false unless config.kind_of?(Hash)

        @disable = Array(config['disable']).map(&:to_sym)
        @enable  = Array(config['enable']).map(&:to_sym)

        @ignore = Array(config['ignore'])

        case (dependencies = config['dependencies'])
        when Hash
          @dependencies.merge!(dependencies)
        when nil
        else
          raise(InvalidTemplate,"template dependencies must be a Hash: #{config_path.dump}")
        end

        case (dependencies = config['development_dependencies'])
        when Hash
          @development_dependencies.merge!(dependencies)
        when nil
        else
          raise(InvalidTemplate,"template dependencies must be a Hash: #{config_path.dump}")
        end

        case (variables = config['variables'])
        when Hash
          variables.each do |name,value|
            @variables[name.to_sym] = value
          end
        when nil
        else
          raise(InvalidTemplate,"template variables must be a Hash: #{config_path.dump}")
        end

        return true
      end

      #
      # Scans the template directory recursively recording the directories,
      # files and partial templates.
      #
      def scan!
        Dir.chdir(@path) do
          Find.find('.') do |file|
            next if file == '.'

            # ignore the ./
            file = file[2..-1]
            name = File.basename(file)

            # ignore certain files/directories
            Find.prune if ignored?(name)

            if File.directory?(file)
              @directories << file
            elsif File.file?(file)
              src = File.join(@path,file)

              case File.extname(name)
              when '.erb'
                # erb template
                if name.start_with?('_')
                  # partial template
                  template_dir  = File.dirname(file)
                  template_name = name[1..-1].chomp('.erb').to_sym

                  @includes[template_dir][template_name] = src
                else
                  dest = file.chomp('.erb')

                  @templates[dest] = src
                end
              else
                # static file
                @files[file] = src
              end
            end
          end
        end
      end

      #
      # Determines whether a file is markup formatted.
      #
      # @param [String] path
      #   The path to the file.
      #
      # @return [Boolean]
      #   Specifies whether the file is formatting.
      #
      def formatted?(path)
        MARKUPS.values.any? { |exts| exts.include?(File.extname(path)) }
      end

      #
      # Determines if a file has a specific type of markup formatting.
      #
      # @param [String] path
      #   The path to the file.
      #
      # @param [Symbol] markup
      #   The specified type of markup.
      #
      # @return [Boolean]
      #   Specifies whether the file contains the given formatting.
      #
      def formatted_like?(path,markup)
        MARKUPS[markup].include?(File.extname(path))
      end

      private
      def ignored?(filename)
        IGNORE.include?(filename) || @ignore.include?(filename)
      end
    end
  end
end
