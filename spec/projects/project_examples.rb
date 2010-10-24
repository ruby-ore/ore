require 'spec_helper'
require 'ore/project'

shared_examples_for 'an Ore Project' do
  it "should have project files" do
    @project.project_files.should_not be_empty
  end

  it "should have a name" do
    @project.name.should_not be_nil
  end

  it "should have a namespace" do
    @project.namespace.should_not be_nil
  end

  it "should have a version" do
    @project.version.major.should == 1
    @project.version.minor.should == 2
    @project.version.patch.should == 3
  end

  it "should have a summary" do
    @project.summary.should_not be_nil
  end

  it "should have a description" do
    @project.description.should_not be_nil
  end

  it "should have authors" do
    @project.authors.should_not be_empty
  end
end
