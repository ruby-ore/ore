require 'ore/config'

require 'thor'
require 'fileutils'
require 'uri'

module Ore
  class CLI < Thor

    default_task :gem

    map '-l' => :list
    map '-u' => :update
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

    desc 'gemspec', 'Dumps a Ruby gemspec for the project'
    method_option :ruby, :type => :boolean,
                         :default => true,
                         :aliases => '-R'
    method_option :yaml, :type => :boolean, :aliases => '-Y'

    def gemspec
      require 'ore/project'

      gemspec = Project.find.to_gemspec
      
      if options.yaml?
        print YAML.dump(gemspec)
      else
        print gemspec.to_ruby
      end
    end

    desc 'gem', 'Builds a RubyGem'

    def gem
      require 'ore/project'

      Project.find.build!
    end

  end
end
