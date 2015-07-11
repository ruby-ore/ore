require 'ore/config'
require 'ore/actions'
require 'ore/naming'
require 'ore/template'

require 'thor/group'
require 'date'
require 'set'
require 'uri'

module Ore
  class Generator < Thor::Group

    include Thor::Actions
    include Actions
    include Naming
    include Template::Interpolations
    include Template::Helpers

    #
    # Defines a generator option.
    #
    # @param [Symbol] name
    #
    # @param [Hash] options
    #
    def self.generator_option(name,options={})
      default = options.fetch(:default,Config.options[name])

      class_option(name,options.merge(default: default))
    end

    Template.templates.each_key do |name|
      # skip the `base` template
      next if name == :gem

      generator_option name, type: :boolean
    end

    # disable the Thor namespace
    namespace ''

    # define the options
    generator_option :markup, type:   :string,
                              banner: 'markdown|textile|rdoc'
    generator_option :markdown, type: :boolean
    generator_option :textile, type: :boolean
    generator_option :templates, type:    :array,
                                 default: [],
                                 aliases: '-T',
                                 banner:  'TEMPLATE [...]'
    generator_option :name, type: :string, aliases: '-n'
    generator_option :namespace, type: :string, aliases: '-N'
    generator_option :version, type:    :string,
                               aliases: '-V'
    generator_option :summary, type:    :string,
                               aliases: '-s'
    generator_option :description, type:    :string,
                                   aliases: '-D'
    generator_option :author,  type: :string,
                               aliases: '-A',
                               banner: 'NAME'
    generator_option :authors, type: :array,
                               aliases: '-a',
                               banner: 'NAME [...]'
    generator_option :email, type: :string, aliases: '-e'
    generator_option :homepage, type: :string, aliases: %w[-U --website]
    generator_option :bug_tracker, type: :string, aliases: '-B'

    argument :path, required: true

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

      extend Template::Helpers::MARKUP.fetch(@markup)

      unless options.quiet?
        say "Generating #{self.destination_root}", :green
      end

      generate_directories!
      generate_files!
      initialize_scm!
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

      return false if @enabled_templates.include?(name)

      unless (template_dir = Template.templates[name])
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

      if (template_dir = Template.templates[name])
        source_paths.delete(template_dir)

        @templates.delete_if { |template| template.path == template_dir }
        @enabled_templates.delete(name)
      end

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
      
      enable_template :gem

      # enable the default templates first
      Options::DEFAULT_TEMPLATES.each do |name|
        if (Template.template?(name) && options[name])
          enable_template(name)
        end
      end

      # enable the templates specified by option
      options.each do |name,value|
        if (Template.template?(name) && value)
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
      @root        = destination_root
      @project_dir = File.basename(@root)
      @name        = (options.name || @project_dir)

      @scm = if    File.directory?(File.join(@root,'.git')) then :git
             elsif File.directory?(File.join(@root,'.hg'))  then :hg
             elsif File.directory?(File.join(@root,'.svn')) then :svn
             elsif options.hg?                              then :hg
             elsif options.git?                             then :git
             end

      case @scm
      when :git
        @scm_user  = `git config user.name`.chomp
        @scm_email = `git config user.email`.chomp

        @github_user = `git config github.user`.chomp
      when :hg
        user_email = `hg showconfig ui.username`.chomp
        user_email.scan(/([^<]+)\s+<([^>]+)>/) do |(user,email)|
          @scm_user, @scm_email = user, email
        end
      end

      @modules      = modules_of(@name)
      @module_depth = @modules.length
      @module       = @modules.last

      @namespace      = options.namespace || namespace_of(@name)
      @namespace_dirs = namespace_dirs_of(@name)
      @namespace_path = namespace_path_of(@name)
      @namespace_dir  = @namespace_dirs.last

      @version     = options.version
      @summary     = options.summary
      @description = options.description

      @authors     = if options.author || options.author
                       [*options.author, *options.authors]
                     else
                       [@scm_user || ENV['USERNAME'] || ENV['USER'].capitalize]
                     end
      @author      = @authors.first

      @email       = (options.email || @scm_email)
      @safe_email  = @email.sub('@',' at ') if @email

      @homepage    = if options.homepage
                       options.homepage
                     elsif !(@github_user.nil? || @github_user.empty?)
                       "https://github.com/#{@github_user}/#{@name}#readme"
                     else
                       "https://rubygems.org/gems/#{@name}"
                     end
      @uri         = URI(@homepage)
      @bug_tracker = case @uri.host
                     when 'github.com'
                       "https://#{@uri.host}#{@uri.path}/issues"
                     end

      @markup = if    options.markdown? then :markdown
                elsif options.textile?  then :textile
                elsif options.markup?   then options.markup.to_sym
                end

      @markup_ext = Template::Markup::EXT.fetch(@markup) do
        say "Unknown markup: #{@markup}", :red
        exit -1
      end

      @date  = Date.today
      @year  = @date.year
      @month = @date.month
      @day   = @date.day

      @ignore                   = SortedSet[]
      @dependencies             = {}
      @development_dependencies = {}

      @templates.each do |template|
        @ignore.merge(template.ignore)

        @dependencies.merge!(template.dependencies)
        @development_dependencies.merge!(template.development_dependencies)

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
          generate_file dest, file, template: true
        end
      end

      @generated_files.each_value do |path|
        dir = path.split(File::SEPARATOR,2).first

        if dir == 'bin'
          chmod path, 0755
        end
      end
    end

    #
    # Initializes the project repository and commits all files.
    #
    # @since 0.10.0
    #
    def initialize_scm!
      in_root do
        case @scm
        when :git
          unless File.directory?('.git')
            run 'git init'
            run 'git add .'
            run 'git commit -m "Initial commit."'
          end
        when :hg
          unless File.directory?('.hg')
            run 'hg init'
            run 'hg add .'
            run 'hg commit -m "Initial commit."'
          end
        when :svn
          @ignore.each do |pattern|
            run "svn propset svn:ignore #{pattern.dump}"
          end

          run 'svn add .'
          run 'svn commit -m "Initial commit."'
        end
      end
    end

  end
end
