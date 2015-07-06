module Ore
  module Template
    module Helpers
      #
      # @api semipublic
      #
      # @since 0.10.0
      #
      module RDoc
        #
        # Emits a RDoc link.
        #
        # @param [String, nil] text
        #
        # @param [String] url
        #
        # @return [String]
        #
        def link_to(text,url)
          "{#{text}}[#{url}]"
        end

        #
        # Emits a RDoc image.
        #
        # @param [String] url
        #
        # @param [String, nil] alt
        #
        # @return [String]
        #
        def image(url,alt=nil)
          "{#{alt}}[rdoc-image:#{url}]"
        end

        #
        # Emits a RDoc h1 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h1(title)
          "= #{title}"
        end

        #
        # Emits a RDoc h2 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h2(title)
          "== #{title}"
        end

        #
        # Emits a RDoc h3 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h3(title)
          "=== #{title}"
        end

        #
        # Emits a RDoc h4 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h4(title)
          "==== #{title}"
        end

        #
        # Emits a RDoc code block.
        #
        # @param [String] code
        #
        # @yield []
        #   The return value of the given block will be used as the code.
        #
        # @return [String]
        #
        def pre(code)
          code.each_line.map { |line| "  #{line}" }.join
        end
      end
    end
  end
end
