module Ore
  module Template
    module Interpolations
      @@keywords = %w[
        name
        project_dir
        namespace_dir
      ]

      protected

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
