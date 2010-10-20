module Helpers
  module Files
    def file(name)
      File.join(File.dirname(__FILE__),'files',name)
    end
  end
end
