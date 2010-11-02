require 'spec_helper'
require 'helpers/generator'
require 'ore/generator'

describe Generator do
  include Helpers::Generator

  context "default" do
    let(:name) { 'my-project' }

    before(:all) do
      @path = generate!(name)
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

  context "yard" do
    let(:name) { 'yard-project' }

    before(:all) do
      @path = generate!(name, :yard => true)
    end

    it "should add a .yardopts file" do
      @path.join('.yardopts').should be_file
    end
  end

  context "yard with markdown" do
    let(:name) { 'yard_markdown-project' }

    before(:all) do
      @path = generate!(name, :yard => true, :markdown => true)
    end

    it "should add a README.md file" do
      @path.join('README.md').should be_file
    end

    it "should add a ChangeLog.md file" do
      @path.join('ChangeLog.md').should be_file
    end
  end

  context "yard with textile" do
    let(:name) { 'yard_textile-project' }

    before(:all) do
      @path = generate!(name, :yard => true, :textile => true)
    end

    it "should add a README.tt file" do
      @path.join('README.tt').should be_file
    end

    it "should add a ChangeLog.tt file" do
      @path.join('ChangeLog.tt').should be_file
    end
  end

  context "bundler" do
    let(:name) { 'bundled_project' }

    before(:all) do
      @path = generate!(name, :bundler => true)
    end

    it "should add a Gemfile" do
      @path.join('Gemfile').should be_file
    end
  end

  context "rspec" do
    let(:name) { 'rspec_project' }

    before(:all) do
      @path = generate!(name, :rspec => true)
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
  end

  context "rspec with bundler" do
    let(:name) { 'bundled_rspec_project' }

    before(:all) do
      @path = generate!(name, :bundler => true, :rspec => true)
    end
  end

  context "jeweler tasks" do
    let(:name) { 'jewelery_project' }

    before(:all) do
      @path = generate!(name, :jeweler_tasks => true)
    end
  end

  context "jeweler tasks with bundler" do
    let(:name) { 'bundled_jewelery_project' }

    before(:all) do
      @path = generate!(name, :bundler => true, :jeweler_tasks => true)
    end
  end

  context "ore tasks" do
    let(:name) { 'ore_project' }

    before(:all) do
      @path = generate!(name, :ore_tasks => true)
    end
  end

  context "ore tasks with bundler" do
    let(:name) { 'bundled_ore_project' }

    before(:all) do
      @path = generate!(name, :bundler => true, :ore_tasks => true)
    end
  end

  after(:all) do
    cleanup!
  end
end
