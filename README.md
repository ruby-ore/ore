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

### SCMs

Ore supports generating [Git][git], [Mercurial][hg] and [SubVersion][svn]
enabled projects.

    $ mine my-project [--git | --hg]

### Gemspec

Ore generates a pure-Ruby gemspec by default. Ore can also generate a
[gemspec.yml] file.

### Tasks

Ore supports generating projects using [Gem::Tasks][rubygems_tasks],
[Bundler::GemHelper][bundler], [Jeweler::Tasks][jeweler] and even
[Gem::PackageTask][gem_package_task].

    $ mine my-project [--rubygems-tasks |
                       --bundler-tasks  |
                       --jeweler-tasks  |
                       --gem-package-task]

### Bundler

Ore can also generate a [Bundler][bundler] project.

    $ mine my-project --bundler

### RVM

Ore also includes an [.rvmrc] template.

    $ mine my-project --rvmrc

### Markup

Ore supports [RDoc][rdoc], [Markdown][markdown] and [Textile][textile] markup.

    $ mine my-project [--rdoc | --markdown | --textile]

### Documentation

Ore supports generating projects with [RDoc][rdoc] or [YARD][yard]
documentation.

    $ mine my-project [--rdoc | --yard]

### Testing

Ore supports generating [RSpec][rspec] or [Test::Unit][test_unit] tests.

    $ mine my-project [--test-unit | --rspec]

### Custom Templates

Additional templates can also be installed from Git:

    $ ore install git://github.com/ruby-ore/mini_test.git
    $ mine my-project --mini-test

## Requirements

* [thor](http://github.com/wycats/thor) ~> 0.14

## Install

    $ gem install ore

## Synopsis

Generate a new project:

    $ mine my_project

Generate a new customized project:

    $ mine my_project --bundler --rspec --yard

Generate a new project using previously installed templates:

    $ mine my_project --bundler --rspec --yard --templates mini_test

Set your github username, so `mine` can generate GitHub project URLs:

    $ git config github.user foobar
    $ mine my_project

Install a custom template:

    $ ore install git://github.com/ruby-ore/mini_test.git

List installed templates:

    $ ore list

Remove a previously installed template:

    $ ore remove mini_test

Add default generator options to `~/.ore/options.yml`:

    gemspec_yml:    true
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

[git]: http://git-scm.com/
[hg]: http://mercurial.selenic.com/
[svn]: http://subversion.tigris.org/
[gemspec.yml]: https://github.com/ruby-ore/ore/blob/master/gemspec.yml
[rubygems_tasks]: https://github.com/postmodern/rubygems-tasks#readme
[bundler]: http://gembundler.com/
[jeweler]: https://github.com/technicalpickles/jeweler#readme
[gem_package_task]: http://rubygems.rubyforge.org/rubygems-update/Gem/PackageTask.html
[.rvmrc]: https://rvm.io/workflow/rvmrc/#project
[rdoc]: http://rdoc.rubyforge.org/
[markdown]: http://daringfireball.net/projects/markdown/
[textile]: http://textile.sitemonks.com/
[yard]: http://yardoc.org/
[rspec]: http://rspec.info/
[test_unit]: http://test-unit.rubyforge.org/
