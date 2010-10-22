require 'ore/project'

require 'bundler/dsl'

module Bundler
  class Dsl

    def gemspec_yml
      ore = Ore::Project.find(Bundler.default_gemfile.dirname)

      ore.dependencies.each do |dep|
        gem(dep.name, *dep.versions)
      end

      ore.runtime_dependencies.each do |dep|
        gem(dep.name, *dep.versions)
      end

      group :development do
        ore.development_dependencies.each do |dep|
          gem(dep.name, *dep.versions)
        end
      end
    end

  end
end
