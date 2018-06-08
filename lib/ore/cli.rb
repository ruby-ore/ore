require 'ore/config'
require 'ore/generator'
require 'ore/version'

require 'thor'
require 'fileutils'
require 'uri'

module Ore
  class CLI < Thor

    map '-l' => :list
    map '-u' => :update
    map '-r' => :remove

    # add a --version option
    map '--version' => :version

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

    desc 'install URI [TEMPLATE_NAME]', 'Installs an Ore template'

    #
    # Installs a template into `~/.ore/templates`.
    #
    # @param [String] uri
    #   The Git URI to install the template from.
    #
    # @param [String,nil] checkout_path
    #   The subdirectory of '~/.ore/templates' into which the template will be
    #   checked out.  Defaults to the path component of uri.
    #
    def install(uri, checkout_path = nil)
      url = URI(uri)

      name = File.basename(checkout_path || url.path).gsub(/\.git$/,'')

      if !checkout_path.nil? && checkout_path.include?(File::SEPARATOR)
         say "Truncating template name from #{checkout_path} to #{name}", :yellow
      end

      path = File.join(Config::TEMPLATES_DIR,name)

      if File.directory?(path)
        say "Template #{name} already installed.", :red
        exit -1
      end

      FileUtils.mkdir_p(path)
      system('git','clone',uri,path)
    end

    desc 'update', 'Updates all installed templates'

    #
    # Updates all previously installed templates.
    #
    def update
      Config.installed_templates do |path|
        say "Updating #{File.basename(path)} ...", :green

        Dir.chdir(path) { system('git','pull','-q') }
      end
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

      FileUtils.rm_rf(path)
    end

    desc 'version', 'Prints the version'

    #
    # Prints {Ore::VERSION}.
    #
    def version
      puts "ore #{Ore::VERSION}"
    end

  end
end
