require 'spec_helper'
require 'helpers/projects'
require 'projects/project_examples'

describe "Jeweler project" do
  include Helpers::Projects

  before(:all) do
    @project = project('jewelery')
  end

  it_should_behave_like 'an Ore Project'

  it "should have a namespace directory" do
    @project.namespace_dir.should == 'jewelery'
  end
end
