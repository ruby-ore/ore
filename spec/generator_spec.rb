require 'spec_helper'
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
      @path.join('lib').should be_directory
    end

    it "should create a file to load the project within lib/" do
      @path.join('lib','my','project.rb').should be_file
    end

    it "should create a namespace directory within lib/" do
      @path.join('lib','my','project').should be_directory
    end

    it "should create a version.rb file within the namespace directory" do
      @path.join('lib','my','project','version.rb').should be_file
    end

    it "should not create the bin/ directory by default" do
      @path.join('bin').should_not be_directory
    end

    it "should create a test/ directory by default" do
      @path.join('test').should_not be_directory
    end

    it "should create a gemspec.yml file" do
      @path.join('gemspec.yml').should be_file
    end

    describe "gemspec.yml" do
      subject { @gemspec }

      it "should have a name" do
        subject['name'].should == 'my-project'
      end

      it "should not contain a version by default" do
        subject.should_not have_key('version')
      end

      it "should a dummy summary" do
        subject['summary'].should_not be_empty
      end

      it "should a description summary" do
        subject['description'].should_not be_empty
      end

      it "should have a license" do
        subject['license'].should == 'MIT'
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
      @path.join('my-project.gemspec').should be_file
    end

    it "should add a .document file" do
      @path.join('.document').should be_file
    end

    it "should add a Rakefile" do
      @path.join('Rakefile').should be_file
    end

    it "should add a README.rdoc file" do
      @path.join('README.rdoc').should be_file
    end

    it "should add a ChangeLog.rdoc file" do
      @path.join('ChangeLog.rdoc').should be_file
    end

    it "should add a LICENSE.txt file" do
      @path.join('LICENSE.txt').should be_file
    end
  end

  context "bin" do
    let(:name)   { 'script-project'      }
    let(:script) { File.join('bin',name) }

    before(:all) do
      generate!(name, :bin => true)
    end

    it "should add a 'bin/' directory" do
      @path.join('bin').should be_directory
    end

    it "should add a bin/script-project file" do
      @path.join(script).should be_file
    end

    it "should make the bin/script-project file executable" do
      @path.join(script).should be_executable
    end
  end

  context "gem test" do
    let(:name) { 'gem_test_project' }

    before(:all) do
      generate!(name, :gem_test => true)
    end

    it "should add a .gemtest file" do
      @path.join('.gemtest').should be_file
    end
  end

  context "bundler" do
    let(:name) { 'bundled_project' }

    before(:all) do
      generate!(name, :bundler => true)
    end

    it "should add a Gemfile" do
      @path.join('Gemfile').should be_file
    end

    it "should add 'bundler' as a development dependency" do
      @gemspec['development_dependencies'].should have_key('bundler')
    end

    it "should add 'Gemfile.lock' to the .gitignore file" do
      gitignore.should include('Gemfile.lock')
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

    it "should set @markup to :rdoc" do
      @generator.instance_variable_get('@markup').should == :rdoc
    end

    it "should add 'html/' to the .gitignore file" do
      gitignore.should include('html/')
    end

    it "should add a '.document' file" do
      @path.join('.document').should be_file
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
      @path.join('.yardopts').should be_file
    end

    it "should add a '.document' file" do
      @path.join('.document').should be_file
    end

    context ".document" do
      it "should not include 'lib/**/*.rb'" do
        document.should_not include('lib/**/*.rb')
      end

      it "should include a '-' separator for non-code files" do
        document.should include('-')
      end

      it "should not include 'README.*'" do
        document.grep(/^README\./).should be_empty
      end

      it "should include 'ChangeLog.*'" do
        document.should include('ChangeLog.*')
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
      @path.join('README.md').should be_file
    end

    it "should add a ChangeLog.md file" do
      @path.join('ChangeLog.md').should be_file
    end

    it "should set --markup to markdown in .yardopts" do
      yard_opts.should include('--markup markdown')
    end
  end

  context "yard with textile" do
    let(:name) { 'yard_textile-project' }

    before(:all) do
      generate!(name, :yard => true, :textile => true)
    end

    it "should add a README.tt file" do
      @path.join('README.tt').should be_file
    end

    it "should add a ChangeLog.tt file" do
      @path.join('ChangeLog.tt').should be_file
    end

    it "should set --markup to textile in .yardopts" do
      yard_opts.should include('--markup textile')
    end
  end

  context "yard with bundler" do
    let(:name) { 'bundled_yard_project' }

    before(:all) do
      generate!(name, :bundler => true, :yard => true)
    end

    it "should still add 'yard' as a development dependency" do
      @gemspec['development_dependencies'].should have_key('yard')
    end
  end

  context "test_unit" do
    let(:name) { 'test_unit_project' }

    before(:all) do
      generate!(name, :test_unit => true)
    end

    it "should disable the rspec template" do
      @generator.disabled_templates.should include(:rspec)
    end

    it "should create the test/ directory" do
      @path.join('test').should be_directory
    end

    it "should create the test/helper.rb file" do
      @path.join('test','helper.rb').should be_file
    end

    it "should add a single test_*.rb file" do
      @path.join('test','test_test_unit_project.rb').should be_file
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

    it "should not create the test/ directory" do
      @path.join('test').should_not be_directory
    end

    it "should create the spec/ directory" do
      @path.join('spec').should be_directory
    end

    it "should add a spec_helper.rb file" do
      @path.join('spec','spec_helper.rb').should be_file
    end

    it "should add a single *_spec.rb file" do
      @path.join('spec','rspec_project_spec.rb').should be_file
    end

    it "should add a .rspec file" do
      @path.join('.rspec').should be_file
    end

    it "should add 'rspec' as a development dependency" do
      @gemspec['development_dependencies'].should have_key('rspec')
    end
  end

  context "rspec with bundler" do
    let(:name) { 'bundled_rspec_project' }

    before(:all) do
      generate!(name, :bundler => true, :rspec => true)
    end

    it "should not add 'rspec' as a development dependency" do
      @gemspec['development_dependencies'].should_not have_key('rspec')
    end
  end

  context "jeweler tasks" do
    let(:name) { 'jewelery_project' }

    before(:all) do
      generate!(name, :jeweler_tasks => true)
    end

    it "should disable the rubygems_tasks template" do
      @generator.disabled_templates.should include(:rubygems_tasks)
    end

    it "should disable the bundler_tasks template" do
      @generator.disabled_templates.should include(:bundler_tasks)
    end

    it "should add 'jeweler' as a development dependency" do
      @gemspec['development_dependencies'].should have_key('jeweler')
    end
  end

  context "jeweler tasks with bundler" do
    let(:name) { 'bundled_jewelery_project' }

    before(:all) do
      generate!(name, :bundler => true, :jeweler_tasks => true)
    end

    it "should not add 'jeweler' as a development dependency" do
      @gemspec['development_dependencies'].should_not have_key('jeweler')
    end
  end

  context "rubygems-tasks" do
    let(:name) { 'rubygems_tasks_project' }

    before(:all) do
      generate!(name, :rubygems_tasks => true)
    end

    it "should disable the jeweler_tasks template" do
      @generator.disabled_templates.should include(:jeweler_tasks)
    end

    it "should disable the bundler_tasks template" do
      @generator.disabled_templates.should include(:bundler_tasks)
    end

    it "should add 'rubygems-tasks' as a development dependency" do
      @gemspec['development_dependencies'].should have_key('rubygems-tasks')
    end
  end

  context "rubygems-tasks with bundler" do
    let(:name) { 'bundled_ore_project' }

    before(:all) do
      generate!(name, :bundler => true, :rubygems_tasks => true)
    end

    it "should not add 'rubygems-tasks' as a development dependency" do
      @gemspec['development_dependencies'].should_not have_key('rubygems-tasks')
    end
  end

  context "bundler_tasks" do
    let(:name) { 'bundler_tasks_project' }

    before(:all) do
      generate!(name, :bundler_tasks => true)
    end

    it "should disable the jeweler_tasks template" do
      @generator.disabled_templates.should include(:jeweler_tasks)
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

    it "should disable the jeweler_tasks template" do
      @generator.disabled_templates.should include(:jeweler_tasks)
    end

    it "should disable the bundler_tasks template" do
      @generator.disabled_templates.should include(:bundler_tasks)
    end
  end

  after(:all) do
    cleanup!
  end
end
