module Ore
  module Template
    module Helpers
      #
      # @api semipublic
      #
      # @since 0.10.0
      #
      module TexTile
        #
        # Emits a TexTile link.
        #
        # @param [String, nil] text
        #
        # @param [String] url
        #
        # @return [String]
        #
        def link_to(text,url)
          if text
            "#{text.dump}:#{url}"
          else
            url
          end
        end

        #
        # Emits a TexTile image tag.
        #
        # @param [String] url
        #
        # @param [String, nil] alt
        #
        # @return [String]
        #
        def image(url,alt=nil)
          "!#{url}(#{alt})!"
        end

        #
        # Emits a TexTile h1 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h1(title)
          "h1. #{title}"
        end

        #
        # Emits a TexTile h2 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h2(title)
          "h2. #{title}"
        end

        #
        # Emits a TexTile h3 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h3(title)
          "h3. #{title}"
        end

        #
        # Emits a TexTile h4 heading.
        #
        # @param [String] title
        #
        # @return [String]
        #
        def h4(title)
          "h4. #{title}"
        end

        #
        # Emits a TexTile code block.
        #
        # @yield []
        #   The return value of the given block will be used as the code.
        #
        # @return [String]
        #
        def pre
          text = yield

          if text =~ /#{$/}\s*#{$/}/
            "bc.. #{text}"
          else
            "bc. #{text}"
          end
        end
      end
    end
  end
end
