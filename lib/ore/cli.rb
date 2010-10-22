require 'ore/config'

require 'thor'
require 'fileutils'
require 'uri'

module Ore
  class CLI < Thor

    default_task :cut

    map '-l' => :list
    map '-r' => :remove

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

    #
    # Installs a template into `~/.ore/templates`.
    #
    # @param [String] uri
    #   The Git URI to install the template from.
    #
    def install(uri)
      url = URI(uri)

      name = File.basename(url.path)
      name.gsub!(/\.git$/,'')

      path = File.join(Config::TEMPLATES_DIR,name)

      if File.directory?(path)
        say "Template #{name} already installed.", :red
        exit -1
      end

      FileUtils.mkdir_p(path)
      system('git','clone',uri,path)
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
