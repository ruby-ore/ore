### 0.7.1 / 2011-02-20

* Added {Ore::Generator#generate_dir}.
* Added {Ore::Generator#generate_file}.
* Only chmod generated files, if they are supposed to be executable.

### 0.7.0 / 2011-02-19

* Require ore-core ~> 0.1, >= 0.1.2.
* Added {Ore::Template::Helpers#git?}.
* Added {Ore::Template::Helpers#bin?}.
* Added the `bin` template and `--bin` option to {Ore::Generator}.
* Enable `--ore-tasks` by default.
* Allow `--jeweler-tasks` to disable `--ore-tasks`.
* Relax ore-tasks dependency to `~> 0.4`.
* Relax rspec dependency to `~> 2.4`.
* Relax ore-core dependency to `~> 0.1`.

### 0.6.0 / 2011-02-12

* Require ore-core ~> 0.1.2.
* Opted into [gem-testers.org](http://gem-testers.org/).
* Added the `rvmrc` template and `--rvmrc` option to {Ore::Generator}:
  * Generates an `.rvmrc` file that creates a new gemset for the project
    and supports Bundler.
* Added `mailto:` to the `Email` links in the generated `README` files.
* Renamed the `ore cut` command to `ore gem`.
* Use `__FILE__` instead of hard-coding the file name into the generated
  `.gemspec` file.
* No longer necessary to require `ore/specification` in the generated
  `Gemfile`:
  * The new generated `.gemspec` files can auto-load `Ore::Specification`.
* Do not include `ore-core` in the generated `Gemfile`, if `ore-tasks`
  has already been included.
* Bumped the `ore-tasks` dependency to `~> 0.4.0` in the `ore_tasks`
  template.
* Fixed typos in the documentation thanks to
  [yard-spellcheck](http://github.com/postmodern/yard-spellcheck).

### 0.5.0 / 2011-01-19

* Require ore-core ~> 0.1.1.
* Require rspec ~> 2.4.0.
* Load default options from `~/.ore/options.yml`.
* Added the `gem_test` template and `--gem-test` to {Ore::Generator}.
  This opts-in projects to be tested via the `gem test` command.
* Auto-define options in {Ore::Generator} for builtin templates.
* Added `lib/ore.rb`.
* Added {Ore::Config.enable!}.
* Added {Ore::Config.disable!}.
* Added {Ore::Config.default_options}.
* Added {Ore::Generator.defaults}.
* Added {Ore::Generator.generator_option}.
* Added `vendor/cache/*.gem` to `.gitignore` if `--bundler` is specified.
* Attempt to auto-load `ore/specification` in the generated `*.gemspec`
  files.

### 0.4.1 / 2010-12-17

* Added a post-install message.
* Added links to [rubydoc.info](http://rubydoc.info) in the README
  templates.
* Add `Gemfile.lock` to the generated `.gitignore` file when `--bundler`
  is used.
* Use `platforms :jruby` and `platforms :ruby` to separate JRuby and
  non-JRuby dependencies when generating the `Gemfile`.
* Fixed the link syntax in the TexTile README template.

### 0.4.0 / 2010-11-24

* Ore Template variables are now loaded from the `variables` Hash within
  a `template.yml` file:

        variables:
          x: foo
          y: bar

* Allow Ore Templates to list other templates to be enabled via the
  `enable` field within a `template.yml` file:

        enable:
         - yard
         - rspec

* Allow Ore Templates to list other templates to be disabled via the
  `disable` field within a `template.yml` file:

        disable:
         - rdoc

* Renamed the `ore_depencency` template variable to `ore_core_dependency`.
* Renamed `@namespace_dir` to `@namespace_path` within {Ore::Generator}.
  * `@namespace_dir` now stores the last sub-directory name, derived from
    the project name.
* Include any `_development_dependencies.erb` and `_dependencies.erb`
  includes into the generated `gemspec.yml` file.
* Added a default Example to generated `README` files.
* Bumped the `ore_tasks_dependency` template variable to `~> 0.3.0`.
* Bumped the `jeweler_dependency` template variable to `~> 1.5.0`.

### 0.3.0 / 2010-11-07

* Split all non-CLI and non-Generator related code out into
  [ore-core](http://github.com/ruby-ore/ore-core).
* {Ore::Generator}:
  * Added {Ore::Template::Helpers#jeweler_tasks?}.
  * Added {Ore::Template::Helpers#ore_tasks?}.
  * Do not include `ore-core` as a development dependency if either
    `--bundler` or `--ore-tasks` is enabled.

### 0.2.3 / 2010-11-01

* Fixed path interpolation on Windows:
  * Windows does not allow the `:` character in paths, so path interpolation
    keywords are now wrapped in `[` and `]` characters.

        interpolate("[name].gemspec")
        # => "my-project.gemspec"

* Do not include `ore-tasks` as a developmnet dependency in generated
  projects that also use Bundler.
* Added more specs to {Ore::Generator} and the builtin templates.

### 0.2.2 / 2010-10-30

* Added `Ore::Project#root`.

### 0.2.1 / 2010-10-29

* Ignore 'ruby' and 'java' from namespace directories returned from
  `Ore::Naming#namespace_dirs_of`.
* Ignore 'ruby' and 'java' from module names returned from
  `Ore::Naming#modules_of`.

### 0.2.0 / 2010-10-27

* Added `Ore::Project#requirements`.
* Added `Ore::Settings#set_requirements!`.
* Added {Ore::Template::InvalidTemplate}.
* Added {Ore::Template::Directory#load!}.
* Suppress `no rubyforge_project specified` warnings by setting the
  `rubyforge_project` to the project name in `Ore::Project#to_gemspec`.
* Do not add extra dependencies to the `gemspec.yml` file when generating
  a Bundler enabled project. Extra dependencies will be added to the
  `Gemfile` and controlled by Bundler.
* Allow Ore template directories to contain `template.yml` which may list
  template variables:

      data:
        variable: Value

### 0.1.4 / 2010-10-26

* Increased documentation coverage.
* Make sure {Ore::Config.builtin_templates} and
  {Ore::Config.installed_templates} only yield valid directories.
* Ensure that `Ore::Settings` handles versions as Strings.
* Fixed two typos.

### 0.1.3 / 2010-10-25

* Fixed URLs in the `gemspec.yml` and {file:README.md}.

### 0.1.2 / 2010-10-25

* Renamed `--jeweler` to `--jeweler-tasks` in {Ore::Generator}.
* Renamed `--ore` to `--ore-tasks` in {Ore::Generator}.
* Fixed the `remove` task in {Ore::CLI}.

### 0.1.1 / 2010-10-25

* Show stopper bug fixed.

### 0.1.0 / 2010-10-25

* Initial release:
  * Added {Ore::Config}.
  * Added `Ore::Naming`.
  * Added `Ore::DocumentFile`.
  * Added `Ore::Versions`:
    * Added `Ore::Versions::Version`.
    * Added `Ore::Versions::VersionConstant`.
    * Added `Ore::Versions::VersionFile`.
  * Added `Ore::Project`:
    * Added `Ore::Checks`.
    * Added `Ore::Defaults`.
    * Added `Ore::Settings`.
  * Added `Ore::Specification`.
  * Added {Ore::Template}:
    * Added {Ore::Template::Directory}.
    * Added {Ore::Template::Interpolations}.
    * Added {Ore::Template::Helpers}.
  * Added {Ore::Generator}.

