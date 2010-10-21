require 'ore/config'

require 'thor'

module Ore
  class CLI < Thor

    default_task :generate

    desc 'list', 'List installed Ore templates'
    def list
    end

    desc 'install URI', 'Installs an Ore template'
    def install(uri)
    end

    desc 'remove NAME', 'Removes an Ore template'
    def remove(name)
    end

    desc 'generate PATH', 'Generates a new RubyGem project'
    method_option :markup, :default => 'rdoc', :aliases => '-m'
    method_option :templates, :type => :array, :aliases => '-T'
    method_option :name, :type => :string, :aliases => '-n'
    method_option :version, :type => :string,
                            :default => '0.1.0',
                            :aliases => '-V'
    method_option :summary, :default => 'TODO: Summary'
    method_option :description, :default => 'TODO: Summary'
    def generate(path)
    end

  end
end
