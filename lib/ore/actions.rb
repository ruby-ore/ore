module Ore
  #
  # Additional actions for the {Generator}.
  #
  # @api semipublic
  #
  # @since 0.9.0
  #
  module Actions
    protected

    #
    # Runs a command.
    #
    # @param [String] command
    #   The command to execute.
    #
    # @param [Hash] config
    #   Additional options.
    #
    # @see http://rubydoc.info/gems/thor/Thor/Actions#run-instance_method
    #
    def run(command,config={})
      super(command,config.merge(capture: true))
    end

    #
    # Generates an empty directory.
    #
    # @param [String] dest
    #   The uninterpolated destination path.
    #
    # @return [String]
    #   The destination path of the directory.
    #
    # @since 0.7.1
    #
    def generate_dir(dest)
      return if @generated_dirs.has_key?(dest)

      path = interpolate(dest)
      empty_directory path

      @generated_dirs[dest] = path
      return path
    end

    #
    # Generates a file.
    #
    # @param [String] dest
    #   The uninterpolated destination path.
    #
    # @param [String] file
    #   The source file or template.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Boolean] :template
    #   Specifies that the file is a template, and should be rendered.
    #
    # @return [String]
    #   The destination path of the file.
    #
    # @since 0.7.1
    #
    def generate_file(dest,file,options={})
      return if @generated_files.has_key?(dest)

      path = interpolate(dest)

      if options[:template]
        @current_template_dir = File.dirname(dest)
        template file, path
        @current_template_dir = nil
      else
        copy_file file, path, mode: :preserve
      end

      @generated_files[dest] = path
      return path
    end
  end
end
