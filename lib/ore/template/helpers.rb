module Ore
  module Template
    module Helpers
      protected

      #
      # Renders all include files with the given name.
      #
      # @param [Symbol] name
      #   The name of the include.
      #
      # @return [String]
      #   The combined result of the rendered include files.
      #
      def includes(name,separator=$/)
        name = name.to_sym
        output_buffer = []

        if @current_template_dir
          context = instance_eval('binding')

          @templates.each do |template|
            if template.includes.has_key?(@current_template_dir)
              path = template.includes[@current_template_dir][name]

              if path
                erb = ERB.new(File.read(path),nil,'-')
                output_buffer << erb.result(context)
              end
            end
          end
        end

        return output_buffer.join(separator)
      end

      #
      # Determines if a template was enabled.
      #
      # @return [Boolean]
      #   Specifies whether the template was enabled.
      #
      def enabled?(name)
        @enabled_templates.include?(name.to_sym)
      end

      #
      # Determines if the project will contain RDoc documented.
      #
      # @return [Boolean]
      #   Specifies whether the project will contain RDoc documented.
      #
      def rdoc?
        options.rdoc?
      end

      #
      # Determines if the project will contain YARD documented.
      #
      # @return [Boolean]
      #   Specifies whether the project will contain YARD documentation.
      #
      def yard?
        enabled?(:yard)
      end

      #
      # Determines if the project is using test-unit.
      #
      # @return [Boolean]
      #   Specifies whether the project is using test-unit.
      #
      def test_unit?
        enabled?(:test_unit)
      end

      #
      # Determines if the project is using RSpec.
      #
      # @return [Boolean]
      #   Specifies whether the project is using RSpec.
      #
      def rspec?
        enabled?(:rspec)
      end

      #
      # Determines if the project is using Bundler.
      #
      # @return [Boolean]
      #   Specifies whether the project is using Bundler.
      #
      def bundler?
        enabled?(:bundler)
      end

      #
      # Creates an indentation string.
      #
      # @param [Integer] n
      #   The number of times to indent.
      #
      # @param [Integer] spaces
      #   The number of spaces to indent by.
      #
      # @return [String]
      #   The indentation string.
      #
      def indent(n,spaces=2)
        (' ' * spaces) * n
      end

      #
      # Escapes data for YAML encoding.
      #
      # @param [String] data
      #   The data to escape.
      #
      # @return [String]
      #   The YAML safe data.
      #
      def yaml_escape(data)
        case data
        when String
          if data =~ /:\s/
            data.dump
          elsif data.include?($/)
            lines = ['']

            data.each_line do |line|
              lines << "  #{line.strip}"
            end

            lines.join($/)
          else
            data
          end
        else
          data.to_s
        end
      end
    end
  end
end
