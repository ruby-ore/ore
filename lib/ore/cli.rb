require 'ore/config'

require 'thor'

module Ore
  class CLI < Thor

    default_task :cut

    map '-l' => :list
    desc 'list', 'List installed Ore templates'

    #
    # Lists builtin and installed templates.
    #
    def list
      print_template = lambda { |path|
        puts "  #{File.basename(path)}"
      }

      say "Builtin templates:", :green
      Config.builtin_templates(&print_template)

      say "Installed templates:", :green
      Config.installed_templates(&print_template)
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
