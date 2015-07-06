module Ore
  module Template
    module Helpers
      #
      # @api semipublic
      #
      # @since 0.10.0
      #
      module Markdown
        #
        # Emits a markdown link.
        #
        # @param [String, nil] text
        #
        # @param [String] url
        #
        # @return [String]
        #
        def link_to(text,url)
          "[#{text}](#{url})"
        end

        #
        # Emits a markdown image.
        #
        # @param [String] url
        #
        # @param [String, nil] alt
        #
        # @return [String]
        #
        def image(url,alt=nil)
          "![#{alt}](#{url})"
        end

        #
        # Emits a markdown h1 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h1(title)
          "# #{title}"
        end

        #
        # Emits a markdown h2 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h2(title)
          "## #{title}"
        end

        #
        # Emits a markdown h3 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h3(title)
          "### #{title}"
        end

        #
        # Emits a markdown h4 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h4(title)
          "#### #{title}"
        end

        #
        # Emits a markdown code block.
        #
        # @param [String] code
        #
        # @yield []
        #   The return value of the given block will be used as the code.
        #
        # @return [String]
        #
        def pre(code)
          code.each_line.map { |line| "    #{line}" }.join
        end
      end
    end
  end
end
