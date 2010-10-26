module Ore
  module Template
    #
    # Handles the expansion of paths and substitution of path keywords.
    # The following keywords are supported:
    #
    # * `:name:` - The name of the project.
    # * `:project_dir:` - The directory base-name derived from the project
    #   name.
    # * `:namespace_dir:` - The full directory path derived from the
    #   project name.
    #
    module Interpolations
      # The accepted interpolation keywords that may be used in paths
      @@keywords = %w[
        name
        project_dir
        namespace_dir
      ]

      protected

      #
      # Expands the given path by substituting the interpolation keywords
      # for the related instance variables.
      #
      # @param [String] path
      #   The path to expand.
      #
      # @return [String]
      #   The expanded path.
      #
      # @example Assuming `@project_dir` contains `my_project`.
      #   interpolate "lib/:project_dir:.rb"
      #   # => "lib/my_project.rb"
      #
      # @example Assuming `@namespace_dir` contains `my/project`.
      #   interpolate "spec/:namespace_dir:_spec.rb"
      #   # => "spec/my/project_spec.rb"
      #
      def interpolate(path)
        dirs = path.split(File::SEPARATOR)

        dirs.each do |dir|
          dir.gsub!(/(:[a-z_]+:)/) do |capture|
            keyword = capture[1..-2]

            if @@keywords.include?(keyword)
              instance_variable_get("@#{keyword}")
            else
              capture
            end
          end
        end

        return File.join(dirs.reject { |dir| dir.empty? })
      end
    end
  end
end
