require 'ore/project'

module Helpers
  module Projects
    def project_dir(name)
      File.join(File.dirname(__FILE__),'projects',name)
    end

    def project(name)
      Ore::Project.find(project_dir(name))
    end
  end
end
