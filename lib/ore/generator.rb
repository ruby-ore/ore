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

    #
    # The templates registered with the generator.
    #
    def self.templates
      @@templates ||= {}
    end

    #
    # Determines whether a template was registered.
    #
    # @param [Symbol, String] name
    #   The name of the template.
    #
    # @return [Boolean]
    #   Specifies whether the template was registered.
    #
    # @since 0.7.2
    #
    def self.template?(name)
      self.templates.has_key?(name.to_sym)
    end

    #
    # Registers a template with the generator.
    #
    # @param [String] path
    #   The path to the template.
    #
    # @return [Symbol]
    #   The name of the registered template.
    #
    # @raise [StandardError]
    #   The given path was not a directory.
    #
    def self.register_template(path)
      unless File.directory?(path)
        raise(StandardError,"#{path.dump} is must be a directory")
      end

      name = File.basename(path).to_sym

      self.templates[name] = path
      return name
    end

    #
    # Default options for the generator.
    #
    # @return [Hash{Symbol => Object}]
    #   The option names and default values.
    #
    # @since 0.5.0
    #
    def self.defaults
      @@defaults ||= {
        :templates      => [],
        :version        => '0.1.0',
        :summary        => 'TODO: Summary',
        :description    => 'TODO: Description',
        :license        => 'MIT',
        :authors        => [ENV['USER']],
        :rubygems_tasks => true,
        :rdoc           => true,
        :rspec          => true,
        :git            => true
      }
    end

    #
    # Defines a generator option.
    #
    # @param [Symbol] name
    #   The name of the option.
    #
    # @param [Hash{Symbol => Object}] options
    #   The Thor options of the option.
    #
    # @since 0.5.0
    #
    def self.generator_option(name,options={})
      class_option(name,options.merge(:default => defaults[name]))
    end

    # The enabled templates.
    attr_reader :enabled_templates

    # The disabled templates.
    attr_reader :disabled_templates

    # The loaded templates.
    attr_reader :templates

    # The generated directories.
    attr_reader :generated_dirs

    # The generated files.
    attr_reader :generated_files

    #
    # Generates a new project.
    #
    def generate
      self.destination_root = path

      enable_templates!
      initialize_variables!

      say "Generating #{self.destination_root}", :green

      generate_directories!
      generate_files!

      in_root do
        if (options.git? && !File.directory?('.git'))
          run 'git init'
          run 'git add .'
          run 'git commit -m "Initial commit."'
        end
      end
    end

    protected

    # merge default options
    defaults.merge!(Config.default_options)

    # register builtin templates
    Config.builtin_templates { |path| register_template(path) }
    # register installed templates
    Config.installed_templates { |path| register_template(path) }

    # define options for all templates
    templates.each_key do |name|
      # skip the `base` template
      next if name == :base

      class_option name, :type    => :boolean,
                         :default => defaults.fetch(name,false)
    end

    # disable the Thor namespace
    namespace ''

    # define the options
    generator_option :markdown, :type => :boolean
    generator_option :textile, :type => :boolean
    generator_option :templates, :type => :array,
                                 :aliases => '-T',
                                 :banner => 'TEMPLATE [...]'
    generator_option :name, :type => :string, :aliases => '-n'
    generator_option :version, :type => :string, :aliases => '-V'
    generator_option :summary, :aliases => '-s'
    generator_option :description, :aliases => '-D'
    generator_option :authors, :type => :array,
                               :aliases => '-a',
                               :banner => 'NAME [...]'
    generator_option :email, :type => :string, :aliases => '-e'
    generator_option :homepage, :type => :string, :aliases => '-U'
    generator_option :license, :aliases => '-L'

    argument :path, :required => true

    #
    # Generates an empty directory.
    #
    # @param [String] dest
    #   The uninterpolated destination path.
    #
    # @return [String]
    #   The destination path of the directory.
    #
    # @since 0.7.1
    #
    def generate_dir(dest)
      return if @generated_dirs.has_key?(dest)

      path = interpolate(dest)
      empty_directory path

      @generated_dirs[dest] = path
      return path
    end

    #
    # Generates a file.
    #
    # @param [String] dest
    #   The uninterpolated destination path.
    #
    # @param [String] file
    #   The source file or template.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Boolean] :template
    #   Specifies that the file is a template, and should be rendered.
    #
    # @return [String]
    #   The destination path of the file.
    #
    # @since 0.7.1
    #
    def generate_file(dest,file,options={})
      return if @generated_files.has_key?(dest)

      path = interpolate(dest)

      if options[:template]
        @current_template_dir = File.dirname(dest)
        template file, path
        @current_template_dir = nil
      else
        copy_file file, path
      end

      @generated_files[dest] = path
      return path
    end

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

      return false if @enabled_templates.include?(name)

      unless (template_dir = self.class.templates[name])
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
      self.source_paths << new_template.path
      return true
    end

    #
    # Disables a template in the generator.
    #
    # @param [Symbol, String] name
    #   The name of the template.
    #
    # @since 0.4.0
    #
    def disable_template(name)
      name = name.to_sym

      return false if @disabled_templates.include?(name)

      unless (template_dir = self.class.templates[name])
        say "Unknown template #{name}", :red
        exit -1
      end

      source_paths.delete(template_dir)

      @templates.delete_if { |template| template.path == template_dir }
      @enabled_templates.delete(name)
      @disabled_templates << name
      return true
    end

    #
    # Enables templates.
    #
    def enable_templates!
      @templates          = []
      @enabled_templates  = Set[]
      @disabled_templates = Set[]
      
      enable_template :base

      # enable the default templates first
      self.class.defaults.each_key do |name|
        if (self.class.template?(name) && options[name])
          enable_template(name)
        end
      end

      # enable the templates specified by option
      options.each do |name,value|
        if (self.class.template?(name) && value)
          enable_template(name)
        end
      end

      # enable any additionally specified templates
      options.templates.each { |name| enable_template(name) }

      # disable any previously enabled templates
      @templates.reverse_each do |template|
        template.disable.each { |name| disable_template(name) }
      end
    end

    #
    # Initializes variables for the templates.
    #
    def initialize_variables!
      @project_dir = File.basename(destination_root)
      @name = (options.name || @project_dir)

      @modules      = modules_of(@name)
      @module_depth = @modules.length
      @module       = @modules.last

      @namespace      = namespace_of(@name)
      @namespace_dirs = namespace_dirs_of(@name)
      @namespace_path = namespace_path_of(@name)

      @version     = options.version
      @summary     = options.summary
      @description = options.description
      @license     = options.license
      @email       = options.email
      @safe_email  = @email.sub('@',' at ') if @email
      @homepage    = (options.homepage || "http://rubygems.org/gems/#{@name}")
      @authors     = options.authors
      @author      = options.authors.first

      @markup = if options.markdown?
                  :markdown
                elsif options.textile?
                  :textile
                else
                  :rdoc
                end

      @date  = Date.today
      @year  = @date.year
      @month = @date.month
      @day   = @date.day

      @dependencies             = {}
      @development_dependencies = {}

      @templates.each do |template|
        @dependencies.merge!(template.dependencies)
        @development_dependencies.merge!(template.development_dependencies)
      end

      @templates.each do |template|
        template.variables.each do |name,value|
          instance_variable_set("@#{name}",value)
        end
      end

      @generated_dirs  = {}
      @generated_files = {}
    end

    #
    # Creates directories listed in the template directories.
    #
    def generate_directories!
      @templates.each do |template|
        template.each_directory do |dir|
          generate_dir dir
        end
      end
    end

    #
    # Copies static files and renders templates in the template directories.
    #
    def generate_files!
      # iterate through the templates in reverse, so files in the templates
      # loaded last override the previously templates.
      @templates.reverse_each do |template|
        # copy in the static files first
        template.each_file(@markup) do |dest,file|
          generate_file dest, file
        end

        # then render the templates
        template.each_template(@markup) do |dest,file|
          generate_file dest, file, :template => true
        end
      end

      @generated_files.each_value do |path|
        dir = path.split(File::SEPARATOR,2).first

        if dir == 'bin'
          chmod path, 0755
        end
      end
    end

  end
end
