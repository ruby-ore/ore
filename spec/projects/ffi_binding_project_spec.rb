require 'spec_helper'
require 'helpers/projects'
require 'projects/project_examples'

describe "FFI Bindings project" do
  include Helpers::Projects

  before(:all) do
    @project = project('ffi-binding')
  end

  it_should_behave_like 'an Ore Project'

  it "should correctly guess the namespace" do
    @project.namespace.should == 'FFI::Binding'
  end

  it "should have a namespace directory" do
    @project.namespace_dir.should == 'ffi/binding'
  end
end
