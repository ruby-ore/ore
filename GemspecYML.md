# gemspec.yml

Ore uses the `gemspec.yml` file to store all static data about a project.
The `gemspec.yml` is a simple YAML file, which contains the same data
that a normal Ruby `.gemspec` file would. Below is the complete listing
of valid data that can be listed in a `gemspec.yml` file.

## name

The name of the project can be listed like so:

    name: foo

If the name is not listed, Ore will use the base-name of the project
directory.

## version

The version of the project can be listed like so:

    version: 0.1.0

If the version is not listed, Ore will first search for a `VERSION` or
`VERSION.yml` file in the root of the project. If Ore cannot find any
version files, it will then search within the `lib/` directory for a
`version.rb`. Ore can load both Ruby `VERSION` constants or `Version`
modules that contain `MAJOR`, `MINOR`, `PATCH` and `BUILD` constants.

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

## authors

The authors of the project can be listed like so:

    author: Alice

If a project has more than one author, each author can be listed:

    author:
     - Alice
     - Eve
     - Bob

## email

The primary email contact for the project can be listed like so:

    email: alice@example.com

## date

The publish date of the current version can be listed like so:

    date: 2010-10-23

Ore will use [Date.parse](http://rubydoc.info/docs/ruby-stdlib/1.9.2/Date.parse)
to parse the `date` value.

If the `date` is not listed, Ore will default it to the current date.

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

## default_executable

The primary executable of the project can be listed like so:

    default_executable: util1

If `default_executable` is not listed, Ore will use the first element
in `executables`.

## has_rdoc

One can specify the project contains [RDoc](http://rdoc.rubyforge.org/)
documentation:

    has_rdoc: true

## has_yard

If the project contains [YARD](http://yardoc.org/) and not
[RDoc](http://rdoc.rubyforge.org/) documentation, one can specify this:

    has_yard: true

If neither `has_yard` or `has_rdoc` are listed, Ore will set `has_yard`
if the `.yardopts` file exists in the root directory of the project.
Otherwise, Ore will default `has_rdoc` to true.

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

    file: lib/**/*.rb

More than one file pattern can be specification:

    file:
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

## dependencies

The dependencies of the project can be listed like so:

    dependencies:
      foo: ~> 0.1.0
      bar: 1.2.3

More than one version can be specified for each dependency:

    dependencies:
      foo: ~> 0.1.0, >= 0.0.7
      bar: 1.2.3, 1.3.1

## runtime_dependencies

The purely runtime-dependencies for a project can be specified like so:

    runtime_dependencies:
      foo: ~> 0.1.0
      bar: 1.2.3

More than one version can be specified for each dependency:

    dependencies:
      foo: ~> 0.1.0, >= 0.0.7
      bar: 1.2.3, 1.3.1

## development_dependencies:

The purely developmental-dependencies for a project can be specified
like so:

    development_dependencies:
      foo: ~> 0.1.0
      bar: 1.2.3

More than one version can be specified for each dependency:

    dependencies:
      foo: ~> 0.1.0, >= 0.0.7
      bar: 1.2.3, 1.3.1

