require 'ore/project'

module Ore
  module Specification

    def Specification.new(&block)
      Project.find.to_gemspec(&block)
    end

  end
end
