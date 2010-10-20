require 'set'

module Ore
  #
  # Parses the contents of a  `.document`.
  #
  class DocumentFile

    NAME = '.document'

    # The path to the `.document` file.
    attr_reader :path

    # The glob-patterns to find all code-files.
    attr_reader :code_file_globs

    # The glob-patterns to find all extra-files.
    attr_reader :extra_file_globs

    #
    # Creates a new {DocumentFile}.
    #
    # @param [String] path
    #   The path of the `.document` file.
    #
    def initialize(path)
      @path = File.expand_path(path)

      @code_file_globs = Set[]
      @extra_file_globs = Set[]

      @code_files = nil
      @extra_files = nil

      parse!
    end

    #
    # All code-files described in the `.document` file.
    #
    # @return [Set<String>]
    #   Every path that matched {#code_file_globs}.
    #
    def code_files
      unless @code_files
        @code_files = Set[]

        @code_file_globs.each do |pattern|
          Dir.glob(pattern) { |path| @code_files << path }
        end
      end

      return @code_files
    end

    #
    # All extra-files described in the `.document` file.
    #
    # @return [Set<String>]
    #   Every path that matched {#extra_file_globs}.
    #
    def extra_files
      unless @extra_files
        @extra_files = Set[]

        @extra_file_globs.each do |pattern|
          Dir.glob(pattern) { |path| @extra_files << path }
        end
      end

      return @extra_files
    end

    protected

    #
    # Parses the contents of a `.document` file.
    #
    def parse!
      separator = false

      File.open(@path) do |file|
        file.each_line do |line|
          line = line.chomp.strip

          next if line.empty?

          unless separator
            if line == '-'
              separator = true
            else
              @code_file_globs << line
            end
          else
            @extra_file_globs << line
          end
        end
      end
    end

  end
end
