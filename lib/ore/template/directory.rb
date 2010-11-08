require 'ore/template/exceptions/invalid_template'

require 'yaml'
require 'find'

module Ore
  module Template
    #
    # Represents a template directory and the static files, ERb files
    # and sub-directories within it.
    #
    class Directory

      # The template configuration file
      @@config_file = 'template.yml'

      # Files or directory names to ignore
      @@ignore = ['.git', @@config_file]

      # The known markup languages and file extensions
      @@markups = {
        :markdown => %w[.md .markdown],
        :textile => %w[.tt .textile],
        :rdoc => %w[.rdoc]
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

      # The variables to use when rendering the template files
      attr_reader :variables

      #
      # Initializes a new template directory.
      #
      # @param [String] path
      #   The path to the template directory.
      #
      def initialize(path)
        @path = File.expand_path(path)

        @directories = []
        @files = {}
        @templates = {}
        @includes = Hash.new { |hash,key| hash[key] = {} }

        @variables = {}

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
        config_path = File.join(@path,@@config_file)
        return false unless File.file?(config_path)

        config = YAML.load_file(config_path)

        unless config.kind_of?(Hash)
          raise(InvalidTemplate,"invalid configuration in #{config_path.dump}")
        end

        if (variables = config['variables'])
          # variables must be a Hash
          unless variables.kind_of?(Hash)
            raise(InvalidTemplate,"template variables must be a Hash: #{config_path.dump}")
          end

          # load the template variables
          variables.each do |name,value|
            @variables[name.to_sym] = value
          end
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
            Find.prune if @@ignore.include?(name)

            if File.directory?(file)
              @directories << file
            elsif File.file?(file)
              src = File.join(@path,file)

              case File.extname(name)
              when '.erb'
                # erb template
                if name[0,1] == '_'
                  # partial template
                  template_dir = File.dirname(file)
                  template_name = name[1...-4].to_sym

                  @includes[template_dir][template_name] = src
                else
                  dest = file[0...-4]

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
        @@markups.values.any? { |exts| exts.include?(File.extname(path)) }
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
      #   Specifies whether the file has the sepcified formatting.
      #
      def formatted_like?(path,markup)
        @@markups[markup].include?(File.extname(path))
      end

    end
  end
end
