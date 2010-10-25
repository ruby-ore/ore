require 'set'

module Ore
  #
  # Parses the contents of a  `.document`.
  #
  class DocumentFile

    # The path to the `.document` file.
    attr_reader :path

    # The glob-patterns to find all code-files.
    attr_reader :file_globs

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

      @file_globs = Set[]
      @extra_file_globs = Set[]

      parse!
    end

    @@file = '.document'

    #
    # Finds the document file in a project.
    #
    # @param [Project] project
    #   The project to search within.
    #
    # @return [DocumentFile, nil]
    #   The found document file.
    #
    def self.find(project)
      self.new(project.path(@@file)) if project.file?(@@file)
    end

    #
    # All files described in the `.document` file.
    #
    # @yield [path]
    #   The given block will be passed every path that matches the file
    #   globs in the `.document` file.
    #
    # @yieldparam [String] path
    #   A match that matches the `.document` file patterns.
    #
    # @return [Enumerator]
    #   If no block was given, an enumerator object will be returned.
    #
    def each_file(&block)
      return enum_for(:each_file) unless block

      @file_globs.each do |pattern|
        Dir.glob(pattern,&block)
      end
    end

    #
    # All extra-files described in the `.document` file.
    #
    # @yield [path]
    #   The given block will be passed every path that matches the
    #   extra-file globs in the `.document` file.
    #
    # @yieldparam [String] path
    #   A match that matches the `.document` extra-file patterns.
    #
    # @return [Enumerator]
    #   If no block was given, an enumerator object will be returned.
    #
    def each_extra_file(&block)
      return enum_for(:each_extra_file) unless block

      @extra_file_globs.each do |pattern|
        Dir.glob(pattern,&block)
      end
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
              @file_globs << line
            end
          else
            @extra_file_globs << line
          end
        end
      end
    end

  end
end
