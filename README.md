# Ore

* [Source](http://github.com/postmodern/ore)
* [Issues](http://github.com/postmodern/ore/issues)
* Postmodern (postmodern.mod3 at gmail.com)

## Description

Ore is a simple RubyGem building solution. Ore handles the creation of
`Gem::Specification` objects as well as building `.gem` files. Ore allows
the developer to keep all of the project information in a single YAML file.

## Features

* Stores project information in **one YAML file** (`gem.yml`).
* **Does not** have additional dependencies.
* **Does not** add additional dependencies to your project.
* **Does not** impose a development workflow onto the developer. One could
  even use Ore with `Jeweler::Tasks`.
* **Can** load the project version from:
  * `VERSION` or `VERSION.yml` files.
  * `VERSION` constants or `Version` modules defined in a `version.rb` file.
* **Can** be used in traditional `.gemspec` files:

        require 'ore/specification'
        
        Ore::Specification.new

## Install

    $ gem install ore

## Synopsis

Builds a `.gem` file in the `pkg/` directory of a project:

    $ ore

## License

See {file:LICENSE.txt} for license information.

