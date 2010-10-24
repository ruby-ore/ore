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
end
