# Ore

* [Source](http://github.com/ruby-ore/ore)
* [Issues](http://github.com/ruby-ore/ore/issues)
* [Documentation](http://rubydoc.info/gems/ore/file/README.md)
* IRC: irc.freenode.net #ruby-ore
* Postmodern (postmodern.mod3 at gmail.com)

## Description

Ore is a simple RubyGem building solution. Ore handles the creation of
`Gem::Specification` objects as well as building `.gem` files. Ore allows
the developer to keep all of the project information in a single YAML file.

## Features

* Stores project information in **one YAML file** (`gemspec.yml`).
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

* Provides an **extendable** project **generator** that supports
  user-installed templates.

## Requirements

* [ore-core](http://github.com/ruby-ore/ore-core) ~> 0.1.1
* [thor](http://github.com/wycats/thor) ~> 0.14.3

## Install

    $ gem install ore

## Example gemspec.yml files

The `gemspec.yml` file used to build Ore:

    name: ore
    version: 0.5.0
    summary: Mine raw RubyGems from YAML.
    description:
      Ore is a simple RubyGem building solution. Ore handles the
      creation of Gem::Specification objects as well as building '.gem'
      files. Ore allows the developer to keep all of the project information
      in a single YAML file.
    
    license: MIT
    authors: Postmodern
    email: postmodern.mod3@gmail.com
    homepage: http://github.com/ruby-ore/ore
    has_yard: true
    post_install_message: |
      **************************************************************************
      Generate a new Ruby library:
      
          $ mine my_library --ore-tasks --rspec
      
      Build the library:
      
          $ rake build
      
      Release the library to rubygems.org:
      
          $ rake release
      
      **************************************************************************
    
    dependencies:
      ore-core: ~> 0.1.1
      thor: ~> 0.14.3
    
    development_dependencies:
      ore-tasks: ~> 0.3.0
      rspec: ~> 2.4.0
      yard: ~> 0.6.1

For a complete refrence to the `gemspec.yml` file, please see the
[GemspecYML Reference](http://rubydoc.info/gems/ore-core/file/GemspecYML.html).

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

Add default generator options to `~/.ore/options.yml`:

    ore_tasks: true
    rspec: true
    yard: true
    markdown: true
    authors:
      - Alice
    email: alice@example.com

Builds a `.gem` file in the `pkg/` directory of a project:

    $ ore

## License

See {file:LICENSE.txt} for license information.

