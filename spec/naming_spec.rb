require 'spec_helper'
require 'ore/naming'

describe Naming do
  subject do
    obj = Object.new
    obj.extend Ore::Naming
    obj
  end

  it "should underscore CamelCase names" do
    subject.underscore('FooBar').should == 'foo_bar'
  end

  it "should not over underscore snake_case names" do
    subject.underscore('Foo_Bar').should == 'foo_bar'
  end

  it "should guess the module names from a project name" do
    subject.modules_of('foo-bar').should == ['Foo', 'Bar']
  end

  it "should recognize common acronyms in project names" do
    subject.modules_of('ffi-bar').should == ['FFI', 'Bar']
  end

  it "should guess the namespace from a project name" do
    subject.namespace_of('foo-bar').should == 'Foo::Bar'
  end

  it "should guess the namespace directories from a project name" do
    subject.namespace_dirs_of('foo-bar').should == ['foo', 'bar']
  end

  it "should guess the namespace directory from a project name" do
    subject.namespace_path_of('foo-bar').should == 'foo/bar'
  end
end
