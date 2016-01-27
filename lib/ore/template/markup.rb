module Ore
  module Template
    module Markup
      # Official file extensions for various markups
      EXT = {
        markdown: 'md',
        textile:  'tt',
        rdoc:     'rdoc'
      }

      # Other common file extensions for various markups
      EXTS = {
        markdown: %w[.md .markdown],
        textile:  %w[.tt .textile],
        rdoc:     %w[.rdoc]
      }
    end
  end
end
