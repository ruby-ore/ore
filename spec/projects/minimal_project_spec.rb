require 'spec_helper'
require 'helpers/projects'
require 'projects/project_examples'

describe "Minimal project" do
  include Helpers::Projects

  before(:all) do
    @project = project('minimal')
  end

  it_should_behave_like 'an Ore Project'

  it "should not have a namespace directory" do
    @project.namespace_dir.should be_nil
  end
end
