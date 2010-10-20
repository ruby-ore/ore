require 'ore/project'

module Ore
  #
  # Acts as a drop-in replacement for calling `Gem::Specification.new`
  # in a projects gemspec file.
  #
  module Specification
    #
    # Creates a new Gem Specification, and automatically populates it
    # using the metadata file.
    #
    # @yield [gemspec]
    #   The given block will be passed the populated Gem Specification
    #   object.
    #
    # @yieldparam [Gem::Specification] gemspec
    #   The newly created Gem Specification.
    #
    # @return [Gem::Specification]
    #   The Gem Specification.
    #
    # @see Project#to_gemspec
    #
    def Specification.new(&block)
      Project.find.to_gemspec(&block)
    end
  end
end
