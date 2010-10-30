### 0.2.2 / 2010-10-30

* Added {Ore::Project#root}.

### 0.2.1 / 2010-10-29

* Ignore 'ruby' and 'java' from namespace directories returned from
  {Ore::Naming#namespace_dirs_of}.
* Ignore 'ruby' and 'java' from module names returned from
  {Ore::Naming#modules_of}.

### 0.2.0 / 2010-10-27

* Added {Ore::Project#requirements}.
* Added {Ore::Settings#set_requirements!}.
* Added {Ore::Template::InvalidTemplate}.
* Added {Ore::Template::Directory#load!}.
* Suppress `no rubyforge_project specified` warnings by setting the
  `rubyforge_project` to the project name in {Ore::Project#to_gemspec}.
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
* Ensure that {Ore::Settings} handles versions as Strings.
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
  * Added {Ore::Naming}.
  * Added {Ore::DocumentFile}.
  * Added {Ore::Versions}:
    * Added {Ore::Versions::Version}.
    * Added {Ore::Versions::VersionConstant}.
    * Added {Ore::Versions::VersionFile}.
  * Added {Ore::Project}:
    * Added {Ore::Checks}.
    * Added {Ore::Defaults}.
    * Added {Ore::Settings}.
  * Added {Ore::Specification}.
  * Added {Ore::Template}:
    * Added {Ore::Template::Directory}.
    * Added {Ore::Template::Interpolations}.
    * Added {Ore::Template::Helpers}.
  * Added {Ore::Generator}.

