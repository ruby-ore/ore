require 'spec_helper'
require 'ore/naming'

describe Naming do
  subject do
    obj = Object.new
    obj.extend Ore::Naming
    obj
  end

  describe "underscore" do
    it "should underscore CamelCase names" do
      subject.underscore('FooBar').should == 'foo_bar'
    end

    it "should not add leading underscores to Capitalized names" do
      subject.underscore('Foo').should == 'foo'
    end

    it "should not add tailing underscores to CamelCase names" do
      subject.underscore('FooX').should == 'foox'
    end

    it "should not add underscores when they already exist" do
      subject.underscore('Foo_Bar').should == 'foo_bar'
    end
  end

  it "should guess the module names from a project name" do
    subject.modules_of('foo-bar').should == ['Foo', 'Bar']
  end

  it "should filter out obvious names from the module names" do
    subject.modules_of('ruby-foo').should == ['Foo']
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

  it "should filter out namespaces that are rarely used in directory names" do
    subject.namespace_dirs_of('ruby-foo').should == ['foo']
  end

  it "should guess the namespace directory from a project name" do
    subject.namespace_path_of('foo-bar').should == 'foo/bar'
  end
end
