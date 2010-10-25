module Ore
  # The path to the `lib/` directory of ore.
  ORE_LIB_DIR = File.expand_path(File.dirname(__FILE__))

  #
  # Provides transparent access to {Ore::Specification}.
  #
  # @param [Symbol] name
  #   The constant name.
  #
  # @return [Object]
  #   The constant.
  #
  # @raise [NameError]
  #   The constant could not be found.
  #
  def self.const_missing(name)
    if name == :Specification
      $LOAD_PATH << ORE_LIB_DIR unless $LOAD_PATH.include?(ORE_LIB_DIR)
      require 'ore/specification'

      return Ore.const_get(name)
    end

    super(name)
  end
end
