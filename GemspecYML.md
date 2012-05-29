# gemspec.yml

Ore uses the `gemspec.yml` file to store all static data about a project.
The `gemspec.yml` is a simple YAML file, which contains the same data
that a normal Ruby `.gemspec` file would. Below is the complete listing
of valid data that can be listed in a `gemspec.yml` file.

## name

The name of the project can be listed like so:

    name: foo

The name of the project must be specified.

## version

The version of the project can be listed like so:

    version: 1.2.3

If the version is not listed, Ore will first search for a `VERSION`
file in the root of the project. If Ore cannot find any version files,
it will then search within the `lib/` directory for a `version.rb`.

## summary

The summary of the project can be listed like so:

    summary: My awesome project

## description

The description of the project can be listed in a variety of ways:

* Single line:

      description: My project, which provides various functionality.

* Text block:

      description:
        My project, which provides the developer with various attributes
        and behaviors.

If the description is not listed, it will default to the `summary`.

## license

The license of the project can be listed like so:

    license: MIT

Multiple licenses can also be listed:

    license:
     - LGPL-2.1
     - GPL-2

## authors

The authors of the project can be listed like so:

    authors: Alice

If a project has more than one author, each author can be listed:

    authors:
     - Alice
     - Eve
     - Bob

## email

The primary email contact for the project can be listed like so:

    email: alice@example.com

If a project has more than one email contact, each email address can be
listed:

    email:
      - alice@example.com
      - eve@example.com
      - bob@example.com

## require_paths

The require_paths of a project can be listed like so:

    require_paths: lib

If there are more than one require_path that needs listing:

    require_paths:
     - ext
     - lib

## executables

The names of the executables provided by the project can be listed like so:

    executables: bin/*

One can also list the executables individually:

    executables:
     - util1
     - util2

If the `executables` are not listed, Ore will use the names of any
executable file within the `bin/` directory.

## extensions

Any Ruby C-extensions can be listed like so:

    extensions: ext/foo/extconf.rb

## documentation

The format of the documentation can be listed like so:

    documentation: yard

## extra_doc_files

The extra files that should also be scanned for documentation can be listed
like so:

    extra_doc_files:
     - ChangeLog.md
     - LICENSE.txt

If `extra_doc_files` is not listed, Ore will use the extra-files listed in
the `.document` file.

## files

The files of the project can be listed like so:

    files: lib/**/*.rb

More than one file pattern can be specification:

    files:
     - lib/**/*.rb
     - spec/**/*
     - data/**/*

If `files` is not listed, Ore will check if the project is using
[Git](http://www.git-scm.org/), can will find all tracked files using:

    git ls-files -z

If the project is not using Git, Ore will default `files` to every file in
the project.

## test_files

The files used to test the project can be listed like so:

    test_files: spec/**/*_spec.rb

More than one test-file pattern can be supplied:

    test_files:
     - spec/**/*_spec.rb
     - features/**/*

If `test_files` is not listed, Ore will default `files` to
`test/{**/}test_*.rb` and `spec/{**/}*_spec.rb`.

## post_install_message

The post-installation message for a project can be listed like so:

    post_install_message: |

      Thank you for installing MyProject 0.1.0. To start MyProject, simply
      run the following command:

      $ my_project
      

## requirements

The external requirements of the project can be listed like so:

    requirements: libcairo >= 1.8

Multiple external requirements can also be listed:

    requirements:
     - libcairo >= 1.8.0
     - libclutter >= 1.2.0

## required_ruby_version

The version of Ruby required by the project can be listed like so:

    required_ruby_version: >= 1.9.1

## required_rubygems_version

The version of RubyGems required by the project can be listed like so:

    required_rubygems_version: >= 1.3.7

If `required_rubygems_version` is not listed and the project uses
[Bundler](http://gembundler.com/), Ore will default `required_rubygems_version`
to `>= 1.3.6`.

## dependencies

The dependencies of the project can be listed like so:

    dependencies:
      foo: ~> 0.1.0
      bar: 1.2.3

More than one version can be specified for each dependency:

    dependencies:
      foo: ~> 0.1.0, >= 0.0.7
      bar:
       - 1.2.3
       - 1.3.1

## development_dependencies

The purely developmental-dependencies for a project can be specified
like so:

    development_dependencies:
      foo: ~> 0.1.0
      bar: 1.2.3

More than one version can be specified for each dependency:

    development_dependencies:
      foo: ~> 0.1.0, >= 0.0.7
      bar:
       - 1.2.3
       - 1.3.1

