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

    #
    # Removes a previously installed template.
    #
    # @param [String] name
    #   The name of the template to remove.
    #
    def remove(name)
      name = File.basename(name)
      path = File.join(Config::TEMPLATES_DIR,name)

      unless File.exists?(path)
        say "Unknown template: #{name}", :red
        exit -1
      end

      File.rm_rf(path)
    end

    desc 'cut', 'Cuts a new RubyGem'

    def cut
      require 'ore/project'

      Project.find.build!
    end

  end
end
