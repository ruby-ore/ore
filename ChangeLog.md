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

