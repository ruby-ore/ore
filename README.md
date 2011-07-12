# Ore

* [Source](http://github.com/ruby-ore/ore)
* [Issues](http://github.com/ruby-ore/ore/issues)
* [Documentation](http://rubydoc.info/gems/ore/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)
* IRC: irc.freenode.net #ruby-ore

## Description

Ore is a flexible Ruby project generator. Unlike other Ruby project
generators, Ore provides many builtin templates and allows custom
templates to be installed from Git repositories.

## Features

* Stores project metadata in **one YAML file** (`gemspec.yml`).
* Generates a **pure Ruby** `.gemspec` supporting:
  * [Git](http://git-scm.com/)
  * [Mercurial (Hg)](http://mercurial.selenic.com/)
  * [SubVersion (SVN)](http://subversion.tigris.org/)
  * `gemspec.yml`
  * `VERSION` or `version.rb` files
* Provides many builtin templates:
  * bundler
  * rvmrc
  * jeweler
  * rdoc
  * yard
  * test_unit
  * rspec
  * gem_test
* Allows installing custom templates from Git repositories:

      $ ore install git://github.com/ruby-ore/cucumber.git

## Requirements

* [ore-core](http://github.com/ruby-ore/ore-core) ~> 0.1, >= 0.1.4
* [env](http://github.com/postmodern/env) ~> 0.1.2
* [thor](http://github.com/wycats/thor) ~> 0.14.3

## Install

    $ gem install ore

## Example gemspec.yml File

The `gemspec.yml` file used to build Ore:

    name: ore
    version: 0.8.1
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
    post_install_message: |
      **************************************************************************
      Generate a new Ruby library:
      
          $ mine my_library --rspec --yard
      
      Build the library:
      
          $ rake build
      
      Release the library to rubygems.org:
      
          $ rake release
      
      **************************************************************************
    
    dependencies:
      ore-core: ~> 0.1, >= 0.1.4
      env: ~> 0.1.2
      thor: ~> 0.14.3
    
    development_dependencies:
      ore-tasks: ~> 0.4
      rspec: ~> 2.4
      yard: ~> 0.7.0

For a complete refrence to the `gemspec.yml` file, please see the
[GemspecYML Reference](http://rubydoc.info/gems/ore/file/GemspecYML.html).

## Synopsis

Install a custom template:

    $ ore install git://github.com/ruby-ore/mini_test.git

List installed templates:

    $ ore list

Remove a previously installed template:

    $ ore remove mini_test

Generate a new project:

    $ mine my_project

Generate a new customized project:

    $ mine my_project --bundler --rspec --yard

Generate a new project using previously installed templates:

    $ mine my_project --bundler --rspec --yard --templates mini_test

Add default generator options to `~/.ore/options.yml`:

    ore_tasks: true
    rspec: true
    yard: true
    markdown: true
    authors:
      - Alice
    email: alice@example.com

Build a `.gem` file in the `pkg/` directory of a project:

    $ ore gem

## License

Copyright (c) 2010-2011 Hal Brodigan

See {file:LICENSE.txt} for license information.
