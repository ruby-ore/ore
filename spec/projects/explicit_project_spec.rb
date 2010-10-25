require 'spec_helper'
require 'helpers/projects'
require 'projects/project_examples'

describe "Explicit project" do
  include Helpers::Projects

  before(:all) do
    @project = project('explicit')
  end

  it_should_behave_like 'an Ore Project'

  it "should have a namespace directory" do
    @project.namespace_dir.should == 'explicit'
  end

  it "should have a license" do
    @project.license.should == 'MIT'
  end

  it "should have a licenses" do
    @project.licenses.should == ['MIT']
  end

  it "should have a required Ruby version" do
    @project.required_ruby_version.should == '>= 1.8.7'
  end

  it "should have a required RubyGems version" do
    @project.required_rubygems_version.should == '>= 1.3.7'
  end
end
