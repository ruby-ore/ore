# Ore

* [github.com/postmodern/ore](http://github.com/postmodern/ore)
* [github.com/postmodern/ore/issues](http://github.com/postmodern/ore/issues)
* Postmodern (postmodern.mod3 at gmail.com)

## Description

Ore is a simple RubyGem building solution. Ore handles the creation of
`Gem::Specification` objects as well as building `.gem` files. Ore allows
the developer to keep all of the project information in a single YAML file.

## Features

* Stores project information in **one YAML file** (`gemspec.yml`).
* Has only **one** dependency ([thor](http://github.com/wycats/thor)).
* **Does not** impose a development workflow onto the developer. One could
  even use Ore with `Jeweler::Tasks`.
* **Can** load the project version from:
  * `VERSION` or `VERSION.yml` files.
  * `VERSION` constants or `Version` modules defined in a `version.rb` file.
* **Can** be used in traditional `.gemspec` files:

      require 'ore/specification'
      
      Ore::Specification.new do |gemspec|
        # custom logic here
      end

* Provides an **extendable** project **generator** that can use
  user-installed templates.

## Requirements

* [thor](http://github.com/wycats/thor) ~> 0.14.3

## Install

    $ gem install ore

## Example gemspec.yml files

The `gemspec.yml` file used to build Ore:

    name: ore
    summary: Cut raw RubyGems from YAML.
    description:
      Ore is a simple RubyGem building solution. Ore handles the
      creation of Gem::Specification objects as well as building '.gem'
      files. Ore allows the developer to keep all of the project information
      in a single YAML file.
    
    license: MIT
    authors: Postmodern
    email: postmodern.mod3@gmail.com
    homepage: http://github.com/postmodern/ore
    has_yard: true
    
    dependencies:
      thor: ~> 0.14.3
    
    development_dependencies:
      yard: ~> 0.6.1
      rspec: ~> 2.0.0

For a complete refrence to the `gemspec.yml` file, please see
{file:GemspecYML.md}.

## Synopsis

Install a custom template:

    $ ore install http://github.com/user/awesometest.git

List installed templates:

    $ ore list

Remove a previously installed template:

    $ ore remove awesometest

Generate a new project:

    $ mine myproj

Generate a new customized project:

    $ mine myproj --bundler --rspec --yard

Generate a new project using previously installed templates:

    $ mine myproj --bundler --rspec --yard -T awesometest

Builds a `.gem` file in the `pkg/` directory of a project:

    $ ore

## License

See {file:LICENSE.txt} for license information.

