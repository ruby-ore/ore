require 'ore/template/directory'
require 'ore/template/interpolations'
require 'ore/template/helpers'
require 'ore/template/template'
require 'ore/config'

# register builtin templates
Ore::Config.builtin_templates { |path| Ore::Template.register(path) }

# register installed templates
Ore::Config.installed_templates { |path| Ore::Template.register(path) }
