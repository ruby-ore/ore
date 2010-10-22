module Ore
  module Interpolations
    KEYWORDS = %w[
      name
      project_dir
      namespace_dir
    ]

    protected

    def interpolate(path)
      dirs = path.split(File::SEPARATOR)

      dirs.each do |dir|
        dir.gsub!(/(:[a-z_]+:)/) do |keyword|
          if KEYWORDS.include?(keyword)
            instance_variable_get("@#{keyword}")
          else
            keyword
          end
        end
      end

      return File.join(dirs.reject { |dir| dir.empty? })
    end
  end
end
