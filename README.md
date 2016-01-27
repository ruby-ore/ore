# Ore

* [Source](https://github.com/ruby-ore/ore)
* [Issues](https://github.com/ruby-ore/ore/issues)
* [Documentation](http://rubydoc.info/gems/ore/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Ore is a fully configurable and customisable Ruby gem generator. With Ore, you
spend less time editing files and more time writing code.

## Features

### SCMs

Ore supports generating [Git][git] (default), [Mercurial][hg] and using
[SubVersion][svn] repositories:

    $ mine my-project [--git | --hg]

### Licenses

Ore supports generating MIT (default), BSD, Apache 2.0, GPLv3 or LGPLv3
licenses:

    $ mine my-project [--mit | --bsd | --apache | --gpl | --lgpl]

### Testing

Ore supports generating [RSpec][rspec] (default), [Minitest][minitest] or
[Test::Unit][test_unit] tests:

    $ mine my-project [--test-unit | --minitest | --rspec]

### TravisCI

Ore also supports generating a [`.travis.yml`][travis.yml] file and README
badge:

    $ mine my-project --travis

### Code Climate

Ore also supports adds Code Climate GPA badges:

    $ mine my-project --code-climate

### Documentation

Ore supports generating projects with [RDoc][rdoc] (default) or [YARD][yard]
documentation:

    $ mine my-project [--rdoc | --yard]

Ore also supports [Markdown][markdown] (default), [Textile][textile] and
[RDoc][rdoc] markups:

    $ mine my-project --yard [--rdoc | --markdown | --textile]

### Bundler

Ore supports [Bundler][bundler] by default. If you do not need bundler, you may
disable it:

    $ mine my-project --no-bundler

### Gem Tasks

Ore supports generating `Rakefile`s using [rubygems/tasks][rubygems_tasks]
(default), [bundler/gem_tasks][bundler] or even
[Gem::PackageTask][gem_package_task]:

    $ mine my-project [--rubygems-tasks | --bundler-tasks  | --gem-package-task]

### Gemspecs

Ore generates a minimal pure-Ruby gemspec by default:

    $ mine my-project

Ore also supports generating a [gemspec.yml] file:

    $ mine my-project --gemspec-yml

Gemspec files support listing files from Git, Hg and SubVersion. If the project
uses Git submodules, the gemspecs will automatically include files from the
submodules.

### Custom Templates

Additional templates can also be installed from Git:

    $ ore install git://github.com/ruby-ore/rbenv.git
    $ mine my-project --rbenv

## Requirements

* [ruby] >= 1.9.1
* [thor] ~> 0.15

## Install

    $ gem install ore

## Synopsis

Generate a new project:

    $ mine my_project

Generate a new customized project:

    $ mine my_project --bundler --rspec --yard

Generate a new project using previously installed templates:

    $ mine my_project --bundler --rspec --yard --templates rbenv

Set your github username, so `mine` can generate GitHub project URLs:

    $ git config github.user foobar
    $ mine my_project

Install a custom template:

    $ ore install git://github.com/ruby-ore/rbenv.git

List installed templates:

    $ ore list

Remove a previously installed template:

    $ ore remove rbenv

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

Copyright (c) 2010-2015 Hal Brodigan

See {file:LICENSE.txt} for license information.

[git]: http://git-scm.com/
[hg]: http://mercurial.selenic.com/
[svn]: http://subversion.tigris.org/
[gemspec.yml]: https://github.com/ruby-ore/ore/blob/master/gemspec.yml
[rubygems_tasks]: https://github.com/postmodern/rubygems-tasks#readme
[bundler]: http://gembundler.com/
[gem_package_task]: http://rubygems.rubyforge.org/rubygems-update/Gem/PackageTask.html
[rdoc]: http://rdoc.rubyforge.org/
[markdown]: http://daringfireball.net/projects/markdown/
[textile]: http://textile.sitemonks.com/
[yard]: http://yardoc.org/
[rspec]: http://rspec.info/
[test_unit]: http://test-unit.rubyforge.org/
[minitest]: https://github.com/seattlerb/minitest#readme
[travis.yml]: http://docs.travis-ci.com/user/languages/ruby/

[ruby]: https://www.ruby-lang.org/
[thor]: https://github.com/wycats/thor#readme
