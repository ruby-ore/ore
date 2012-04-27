# Ore

* [Source](https://github.com/ruby-ore/ore)
* [Issues](https://github.com/ruby-ore/ore/issues)
* [Documentation](http://rubydoc.info/gems/ore/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

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
  * Loads metadata from `gemspec.yml`
  * Loads version from `version.rb`
* Provides many builtin templates:
  * bundler
  * rvmrc
  * gem_package_task
  * rubygems_tasks
  * bundler_tasks
  * jeweler_tasks
  * rdoc
  * yard
  * test_unit
  * rspec
  * gem_test
* Allows installing custom templates from Git repositories:

      $ ore install git://github.com/ruby-ore/cucumber.git

## Requirements

* [thor](http://github.com/wycats/thor) ~> 0.14.3

## Install

    $ gem install ore

## Example gemspec.yml File

The `gemspec.yml` file used to build Ore:

    name: ore
    version: 0.9.0
    summary: Mine raw RubyGems from YAML
    description:
      Ore is a flexible Ruby project generator. Unlike other Ruby project
      generators, Ore provides many builtin templates and allows custom
      templates to be installed from Git repositories.
    
    license: MIT
    authors: Postmodern
    email: postmodern.mod3@gmail.com
    homepage: https://github.com/ruby-ore/ore
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
      thor: ~> 0.14.3
    
    development_dependencies:
      rubygems-tasks: ~> 0.1
      rspec: ~> 2.4
      yard: ~> 0.7

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

    rubygems_tasks: true
    rspec:          true
    yard:           true
    markdown:       true
    authors:
      - Alice
    email: alice@example.com

## License

Copyright (c) 2010-2012 Hal Brodigan

See {file:LICENSE.txt} for license information.
