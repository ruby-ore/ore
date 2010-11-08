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
    # Enables a template, adding it to the generator.
    #
    # @param [Symbol, String] name
    #   The name of the template to add.
    #
    # @since 0.4.0
    #
    def enable_template(name)
      name = name.to_sym

      unless @enabled_templates.include?(name)
        unless (template_dir = Generator.templates[name])
          say "Unknown template #{name}", :red
          exit -1
        end

        new_template = Template::Directory.new(template_dir)

        # mark the template as enabled
        @enabled_templates << name

        # enable any other templates
        new_template.enable.each do |sub_template|
          enable_template(sub_template)
        end

        # append the new template to the end of the list,
        # to override previously loaded templates
        @templates << new_template

        # add the template directory to the source-paths
        self.source_paths << template_dir
      end
    end

    #
    # Enables templates.
    #
    def enable_templates!
      @templates = []
      @enabled_templates = []
      
      enable_template(@@base_template)

      enable_template(:bundler) if options.bundler?
      enable_template(:jeweler_tasks) if options.jeweler_tasks?
      enable_template(:ore_tasks) if options.ore_tasks?
      
      if options.rspec?
        enable_template(:rspec)
      elsif options.test_unit?
        enable_template(:test_unit)
      end

      if options.yard?
        enable_template(:yard)
      elsif options.rdoc?
        enable_template(:rdoc)
      end

      options.templates.each { |name| enable_template(name) }
    end

    #
    # Initializes variables for the templates.
    #
    def initialize_variables!
      @project_dir = File.basename(destination_root)
      @name = (options.name || @project_dir)

      @modules = modules_of(@name)
      @module_depth = @modules.length
      @module = @modules.last

      @namespace = namespace_of(@name)
      @namespace_dirs = namespace_dirs_of(@name)
      @namespace_path = namespace_path_of(@name)
      @namespace_dir = @namespace_dirs.last

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
        template.variables.each do |name,value|
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

      # iterate through the templates in reverse, so files in the templates
      # loaded last override the previously templates.
      @templates.reverse_each do |template|
        # copy in the static files first
        template.each_file(@markup) do |dest,file|
          unless generated.include?(dest)
            path = interpolate(dest)
            copy_file file, path

            generated << dest
          end
        end

        # then render the templates
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
