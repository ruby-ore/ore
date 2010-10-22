require 'ore/config'

require 'thor'

module Ore
  class CLI < Thor

    default_task :cut

    desc 'list', 'List installed Ore templates'

    def list
    end

    desc 'install URI', 'Installs an Ore template'

    def install(uri)
    end

    desc 'remove NAME', 'Removes an Ore template'

    def remove(name)
    end

    desc 'cut', 'Cuts a new RubyGem'

    def cut
      require 'ore/project'

      Project.find.build!
    end

  end
end
