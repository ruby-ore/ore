require 'ore/template/directory'
require 'ore/template/interpolations'
require 'ore/template/helpers'
require 'ore/naming'
require 'ore/config'

require 'thor/group'
require 'date'
require 'set'

module Ore
  class Generator < Thor::Group

    include Thor::Actions
    include Naming
    include Template::Interpolations
    include Template::Helpers

    # The base template for all RubyGems
    @@base_template = :base

    #
    # The templates registered with the generator.
    #
    def Generator.templates
      @templates ||= {}
    end

    #
    # Registers a template with the generator.
    #
    # @param [String] path
    #   The path to the template.
    #
    # @raise [StandardError]
    #   The given path was not a directory.
    #
    def Generator.register_template(path)
      unless File.directory?(path)
        raise(StandardError,"#{path.dump} is must be a directory")
      end

      name = File.basename(path).to_sym
      Generator.templates[name] = path
    end

    Config.builtin_templates { |path| Generator.register_template(path) }
    Config.installed_templates { |path| Generator.register_template(path) }

    namespace ''

    class_option :markdown, :type => :boolean, :default => false
    class_option :textile, :type => :boolean, :default => false
    class_option :templates, :type => :array,
                             :default => [],
                             :aliases => '-T'
    class_option :name, :type => :string, :aliases => '-n'
    class_option :version, :type => :string,
                            :default => '0.1.0',
                            :aliases => '-V'
    class_option :summary, :default => 'TODO: Summary',
                           :aliases => '-s'
    class_option :description, :default => 'TODO: Description',
                               :aliases => '-D'
    class_option :license, :default => 'MIT', :aliases => '-L'
    class_option :homepage, :type => :string, :aliases => '-U'
    class_option :email, :type => :string, :aliases => '-e'
    class_option :authors, :type => :array,
                           :default => [ENV['USER']], :aliases => '-a'
    class_option :rdoc, :type => :boolean, :default => true
    class_option :yard, :type => :boolean, :default => false
    class_option :test_unit, :type => :boolean, :default => false
    class_option :rspec, :type => :boolean, :default => true
    class_option :bundler, :type => :boolean, :default => false
    class_option :jeweler_tasks, :type => :boolean, :default => false
    class_option :ore_tasks, :type => :boolean, :default => false
    class_option :git, :type => :boolean, :default => true
    argument :path, :required => true

    def generate
      self.destination_root = path

      enable_templates!
      load_templates!
      initialize_variables!

      say "Generating #{self.destination_root}", :green

      generate_directories!
      generate_files!

      if options.git?
        in_root do
          unless File.directory?('.git')
            run 'git init'
            run 'git add .'
            run 'git commit -m "Initial commit."'
          end
        end
      end
    end

    protected

    #
    # Enables templates.
    #
    def enable_templates!
      @enabled_templates = [@@base_template]

      @enabled_templates << :bundler if options.bundler?
      @enabled_templates << :jeweler_tasks if options.jeweler_tasks?
      @enabled_templates << :ore_tasks if options.ore_tasks?
      
      if options.rspec?
        @enabled_templates << :rspec
      elsif options.test_unit?
        @enabled_templates << :test_unit
      end

      if options.yard?
        @enabled_templates << :yard
      elsif options.rdoc?
        @enabled_templates << :rdoc
      end

      options.templates.each do |name|
        name = name.to_sym

        unless @enabled_templates.include?(name)
          @enabled_templates << name
        end
      end
    end

    #
    # Loads the given templates.
    #
    def load_templates!
      @templates = []
      
      @enabled_templates.each do |name|
        unless (template_dir = Generator.templates[name])
          say "Unknown template #{name.dump}", :red
          exit -1
        end

        @templates << Template::Directory.new(template_dir)
        self.source_paths << template_dir
      end
    end

    #
    # Initializes variables for the templates.
    #
    def initialize_variables!
      @ore_dependency = '~> 0.2.0'

      @project_dir = File.basename(destination_root)
      @name = (options.name || @project_dir)

      @modules = modules_of(@name)
      @module_depth = @modules.length
      @module = @modules.last

      @namespace = namespace_of(@name)
      @namespace_dirs = namespace_dirs_of(@name)
      @namespace_dir = namespace_path_of(@name)

      @version = options.version
      @summary = options.summary
      @description = options.description
      @license = options.license
      @email = options.email
      @safe_email = @email.sub('@',' at ') if @email
      @homepage = (options.homepage || "http://rubygems.org/gems/#{@name}")
      @authors = options.authors
      @author = options.authors.first

      @markup = if options.yard?
                  if options.markdown?
                    :markdown
                  elsif options.textile?
                    :textile
                  else
                    :rdoc
                  end
                else
                  :rdoc
                end

      @date = Date.today
      @year = @date.year
      @month = @date.month
      @day = @date.day

      @templates.each do |template|
        template.data.each do |name,value|
          instance_variable_set("@#{name}",value)
        end
      end
    end

    #
    # Creates directories listed in the template directories.
    #
    def generate_directories!
      generated = Set[]

      @templates.each do |template|
        template.each_directory do |dir|
          unless generated.include?(dir)
            path = interpolate(dir)
            empty_directory path

            generated << dir
          end
        end
      end
    end

    #
    # Copies static files and renders templates in the template directories.
    #
    def generate_files!
      generated = Set[]

      @templates.reverse_each do |template|
        template.each_file(@markup) do |dest,file|
          unless generated.include?(dest)
            path = interpolate(dest)
            copy_file file, path

            generated << dest
          end
        end

        template.each_template(@markup) do |dest,file|
          unless generated.include?(dest)
            path = interpolate(dest)

            @current_template_dir = File.dirname(dest)
            template file, path
            @current_template_dir = nil

            generated << dest
          end
        end
      end
    end

  end
end
