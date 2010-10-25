module Ore
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
      begin
        # attempt to load 'ore/specification' from the $LOAD_PATH
        require 'ore/specification'
      rescue ::LoadError
        # find our `lib/` directory
        lib_dir = File.expand_path(File.dirname(__FILE__))

        # modify the $LOAD_PATH is 'ore/specification' is not available
        $LOAD_PATH << ORE_LIB_DIR unless $LOAD_PATH.include?(ORE_LIB_DIR)

        begin
          # attempt loading 'ore/specification' again
          require 'ore/specification'
        rescue ::LoadError
          # ore is probably not installed, so raise a NameError
          return super(name)
        end
      end

      return Ore.const_get(name)
    end

    super(name)
  end
end
