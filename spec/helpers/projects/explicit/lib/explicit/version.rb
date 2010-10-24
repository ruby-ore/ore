module Explicit
  module Version
    MAJOR = 1

    MINOR = 2

    PATCH = 3

    VERSION = [MAJOR, MINOR, PATCH].join('.')

    def self.to_s
      VERSION
    end
  end
end
