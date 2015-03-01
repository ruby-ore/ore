require 'spec_helper'
require 'gemspec_examples'
require 'helpers/generator'
require 'ore/generator'

describe Generator do
  include Helpers::Generator

  context "default" do
    let(:name) { 'my-project' }

    before(:all) do
      generate!(name)
    end

    it "should create the project root directory" do
      @path.should be_directory
    end

    it "should create the lib/ directory" do
      @path.should have_directory('lib')
    end

    it "should create a file to load the project within lib/" do
      @path.should have_file('lib','my','project.rb')
    end

    it "should create a namespace directory within lib/" do
      @path.should have_directory('lib','my','project')
    end

    it "should create a version.rb file within the namespace directory" do
      @path.should have_file('lib','my','project','version.rb')
    end

    it "should not create the bin/ directory by default" do
      @path.should_not have_directory('bin')
    end

    it "should create a test/ directory by default" do
      @path.should_not have_directory('test')
    end

    it "should add a *.gemspec file" do
      @path.join("#{name}.gemspec").should be_file
    end

    it "should add a .document file" do
      @path.should have_file('.document')
    end

    it "should add a Rakefile" do
      @path.should have_file('Rakefile')
    end

    it "should add a README.rdoc file" do
      @path.should have_file('README.rdoc')
    end

    it "should add a ChangeLog.rdoc file" do
      @path.should have_file('ChangeLog.rdoc')
    end

    it "should add a LICENSE.txt file" do
      @path.should have_file('LICENSE.txt')
    end
  end

  context "gemspec_yml" do
    let(:name) { 'gemspec_yml_project' }

    before(:all) do
      generate!(name, :gemspec_yml => true)
    end

    it "should add a gemspec.yml file" do
      @path.should have_file('gemspec.yml')
    end

    describe "gemspec.yml" do
      subject { YAML.load_file(@path.join('gemspec.yml')) }

      it "should have a name" do
        subject['name'].should == name
      end

      it "should not contain a version by default" do
        subject.should_not have_key('version')
      end

      it "should a dummy summary" do
        subject['summary'].should == Ore::Options::DEFAULT_SUMMARY
      end

      it "should a dummy description" do
        subject['description'].should == Ore::Options::DEFAULT_DESCRIPTION
      end

      it "should have a license" do
        subject['license'].should == Ore::Options::DEFAULT_LICENSE
      end

      it "should have authors" do
        subject['authors'].should_not be_empty
      end

      it "should have a dummy homepage" do
        subject['homepage'].should_not be_empty
      end

      it "should have 'rubygems-tasks' as a development dependency" do
        subject['development_dependencies'].should have_key('rubygems-tasks')
      end
    end

    it "should add a *.gemspec file" do
      @path.should have_file("#{name}.gemspec")
    end

    describe "*.gemspec file" do
      subject { @gemspec }

      it_should_behave_like "a gemspec"
    end
  end

  context "gemspec" do
    let(:name) { 'gemspec_project' }

    before(:all) do
      generate!(name, :gemspec => true)
    end

    it "should disable the gemspec_yml template" do
      @generator.disabled_templates.should include(:gemspec_yml)
    end

    it "should add a *.gemspec file" do
      @path.should have_file("#{name}.gemspec")
    end

    context "*.gemspec file" do
      subject { @gemspec }

      it_should_behave_like "a gemspec"

      it "should have 'rubygems-tasks' as a development dependency" do
        subject.should have_development_dependency('rubygems-tasks')
      end
    end
  end

  context "git" do
    let(:name)   { 'git-project'      }

    before(:all) do
      generate!(name, :git => true)
    end

    it "should create a .git directory" do
      @path.should have_directory('.git')
    end

    it "should create a .gitignore file" do
      @path.should have_file('.gitignore')
    end
  end

  context "hg" do
    let(:name)   { 'hg-project'      }

    before(:all) do
      generate!(name, :hg => true)
    end

    it "should create a .hg directory" do
      @path.should have_directory('.hg')
    end

    it "should create a .hgignore file" do
      @path.should have_file('.hgignore')
    end
  end

  context "bin" do
    let(:name)   { 'script-project'      }
    let(:script) { File.join('bin',name) }

    before(:all) do
      generate!(name, :bin => true)
    end

    it "should add a 'bin/' directory" do
      @path.should have_directory('bin')
    end

    it "should add a bin/script-project file" do
      @path.should have_file(script)
    end

    it "should make the bin/script-project file executable" do
      @path.should have_executable(script)
    end
  end

  context "bundler" do
    let(:name) { 'bundled_project' }

    before(:all) do
      generate!(name, :bundler => true)
    end

    it "should add a Gemfile" do
      @path.should have_file('Gemfile')
    end

    it "should add 'bundler' as a development dependency" do
      @gemspec.should have_development_dependency('bundler')
    end

    it "should not have any dependencies in the Gemfile" do
      gemfile = (@path + 'Gemfile').read
      gemfile.should eq(<<-GEMFILE)
source 'https://rubygems.org'

gemspec
      GEMFILE
    end

    it "should add 'Gemfile.lock' to the .gitignore file" do
      gitignore.should include('/Gemfile.lock')
    end
  end

  context "rdoc" do
    let(:name) { 'rdoc-project' }

    before(:all) do
      generate!(name, :rdoc => true)
    end

    it "should disable the yard template" do
      @generator.disabled_templates.should include(:yard)
    end

    it "should add 'rdoc' as a development dependency" do
      @gemspec.should have_development_dependency('rdoc')
    end

    it "should set @markup to :rdoc" do
      @generator.instance_variable_get('@markup').should == :rdoc
    end

    it "should add 'html/' to the .gitignore file" do
      gitignore.should include('/html/')
    end

    it "should add a '.document' file" do
      @path.should have_file('.document')
    end

    context ".document" do
      it "should include 'lib/**/*.rb'" do
        document.should include('lib/**/*.rb')
      end

      it "should include 'README.rdoc'" do
        document.should include('README.rdoc')
      end

      it "should include 'ChangeLog.rdoc'" do
        document.should include('ChangeLog.rdoc')
      end

      it "should include 'LICENSE.txt'" do
        document.should include('LICENSE.txt')
      end
    end
  end

  context "yard" do
    let(:name) { 'yard-project' }

    before(:all) do
      generate!(name, :yard => true)
    end

    it "should disable the rdoc template" do
      @generator.disabled_templates.should include(:rdoc)
    end

    it "should add a .yardopts file" do
      @path.should have_file('.yardopts')
    end

    it "should add a '.document' file" do
      @path.should have_file('.document')
    end

    it "should add 'yard' as a development dependency" do
      @gemspec.should have_development_dependency('yard')
    end

    context ".document" do
      it "should not include 'lib/**/*.rb'" do
        document.should_not include('lib/**/*.rb')
      end

      it "should include a '-' separator for non-code files" do
        document.should include('-')
      end

      it "should not include 'README.rdoc'" do
        document.should_not include('README.rdoc')
      end

      it "should include 'ChangeLog.rdoc'" do
        document.should include('ChangeLog.rdoc')
      end

      it "should include 'LICENSE.txt'" do
        document.should include('LICENSE.txt')
      end
    end
  end

  context "yard with markdown" do
    let(:name) { 'yard_markdown-project' }

    before(:all) do
      generate!(name, :yard => true, :markdown => true)
    end

    it "should add a README.md file" do
      @path.should have_file('README.md')
    end

    it "should add a ChangeLog.md file" do
      @path.should have_file('ChangeLog.md')
    end

    it "should set --markup to markdown in .yardopts" do
      yard_opts.should include('--markup markdown')
    end

    context ".document" do
      it "should include 'ChangeLog.md'" do
        document.should include('ChangeLog.md')
      end
    end
  end

  context "yard with textile" do
    let(:name) { 'yard_textile-project' }

    before(:all) do
      generate!(name, :yard => true, :textile => true)
    end

    it "should add a README.tt file" do
      @path.should have_file('README.tt')
    end

    it "should add a ChangeLog.tt file" do
      @path.should have_file('ChangeLog.tt')
    end

    it "should set --markup to textile in .yardopts" do
      yard_opts.should include('--markup textile')
    end

    context ".document" do
      it "should include 'ChangeLog.tt'" do
        document.should include('ChangeLog.tt')
      end
    end
  end

  context "yard with bundler" do
    let(:name) { 'bundled_yard_project' }

    before(:all) do
      generate!(name, :bundler => true, :yard => true)
    end

    it "should still add 'yard' as a development dependency" do
      @gemspec.should have_development_dependency('yard')
    end
  end

  context "test_unit" do
    let(:name) { 'test_unit_project' }

    before(:all) do
      generate!(name, :test_unit => true)
    end

    it "should disable the minitest template" do
      @generator.disabled_templates.should include(:minitest)
    end

    it "should disable the rspec template" do
      @generator.disabled_templates.should include(:rspec)
    end

    it "should create the test/ directory" do
      @path.should have_directory('test')
    end

    it "should create the test/helper.rb file" do
      @path.should have_file('test','helper.rb')
    end

    it "should add a single test_*.rb file" do
      @path.should have_file('test',"test_#{name}.rb")
    end
  end

  context "minitest" do
    let(:name) { 'minitest_project' }

    before(:all) do
      generate!(name, :minitest => true)
    end

    it "should disable the test_unit template" do
      @generator.disabled_templates.should include(:test_unit)
    end

    it "should disable the rspec template" do
      @generator.disabled_templates.should include(:rspec)
    end

    it "should create the test/ directory" do
      @path.should have_directory('test')
    end

    it "should create the test/helper.rb file" do
      @path.should have_file('test','helper.rb')
    end

    it "should add a single test_*.rb file" do
      @path.should have_file('test',"test_#{name}.rb")
    end
  end

  context "rspec" do
    let(:name) { 'rspec_project' }

    before(:all) do
      generate!(name, :rspec => true)
    end

    it "should disable the test_unit template" do
      @generator.disabled_templates.should include(:test_unit)
    end

    it "should disable the minitest template" do
      @generator.disabled_templates.should include(:minitest)
    end

    it "should not create the test/ directory" do
      @path.should_not have_directory('test')
    end

    it "should create the spec/ directory" do
      @path.should have_directory('spec')
    end

    it "should add a spec_helper.rb file" do
      @path.should have_file('spec','spec_helper.rb')
    end

    it "should add a single *_spec.rb file" do
      @path.should have_file('spec','rspec_project_spec.rb')
    end

    it "should add a .rspec file" do
      @path.should have_file('.rspec')
    end

    it "should add 'rspec' as a development dependency" do
      @gemspec.should have_development_dependency('rspec')
    end
  end

  context "rspec with bundler" do
    let(:name) { 'bundled_rspec_project' }

    before(:all) do
      generate!(name, :bundler => true, :rspec => true)
    end

    it "should add 'rspec' as a development dependency" do
      @gemspec.should have_development_dependency('rspec')
    end
  end

  context "rubygems-tasks" do
    let(:name) { 'rubygems_tasks_project' }

    before(:all) do
      generate!(name, :rubygems_tasks => true)
    end

    it "should disable the bundler_tasks template" do
      @generator.disabled_templates.should include(:bundler_tasks)
    end

    it "should add 'rubygems-tasks' as a development dependency" do
      @gemspec.should have_development_dependency('rubygems-tasks')
    end
  end

  context "rubygems-tasks with bundler" do
    let(:name) { 'bundled_ore_project' }

    before(:all) do
      generate!(name, :bundler => true, :rubygems_tasks => true)
    end

    it "should add 'rubygems-tasks' as a development dependency" do
      @gemspec.should have_development_dependency('rubygems-tasks')
    end
  end

  context "bundler_tasks" do
    let(:name) { 'bundler_tasks_project' }

    before(:all) do
      generate!(name, :bundler_tasks => true)
    end

    it "should disable the rubygems_tasks template" do
      @generator.disabled_templates.should include(:rubygems_tasks)
    end

    it "should enable the bundler template" do
      @generator.enabled_templates.should include(:bundler)
    end
  end

  context "gem_package_task" do
    let(:name) { 'gem_package_task_project' }

    before(:all) do
      generate!(name, :gem_package_task => true)
    end

    it "should disable the rubygems_tasks template" do
      @generator.disabled_templates.should include(:rubygems_tasks)
    end

    it "should disable the bundler_tasks template" do
      @generator.disabled_templates.should include(:bundler_tasks)
    end
  end

  after(:all) do
    cleanup!
  end
end
