module Ore
  class Generator

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
    def Generator.register_template(path)
      path = File.expand_path(path)
      Generator.templates[File.basename(path)] = path
    end

    protected

    def find_files(name)
      []
    end

    def find_partials(name)
      find_files("_#{name}")
    end

    def find_templates(name)
      find_files("#{name}.erb")
    end

    def find_markup_files(name)
      name = "#{name}.#{@markup}"

      return find_templates(name) + find_files(name)
    end

  end
end
