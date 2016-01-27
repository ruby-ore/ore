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
      expect(subject.underscore('FooBar')).to eq('foo_bar')
    end

    it "should not add leading underscores to Capitalized names" do
      expect(subject.underscore('Foo')).to eq('foo')
    end

    it "should not add tailing underscores to CamelCase names" do
      expect(subject.underscore('FooX')).to eq('foox')
    end

    it "should not add underscores when they already exist" do
      expect(subject.underscore('Foo_Bar')).to eq('foo_bar')
    end
  end

  it "should guess the module names from a project name" do
    expect(subject.modules_of('foo-bar')).to eq(['Foo', 'Bar'])
  end

  it "should filter out obvious names from the module names" do
    expect(subject.modules_of('ruby-foo')).to eq(['Foo'])
  end

  it "should recognize common acronyms in project names" do
    expect(subject.modules_of('ffi-bar')).to eq(['FFI', 'Bar'])
  end

  it "should guess the namespace from a project name" do
    expect(subject.namespace_of('foo-bar')).to eq('Foo::Bar')
  end

  it "should guess the namespace directories from a project name" do
    expect(subject.namespace_dirs_of('foo-bar')).to eq(['foo', 'bar'])
  end

  it "should filter out namespaces that are rarely used in directory names" do
    expect(subject.namespace_dirs_of('ruby-foo')).to eq(['foo'])
  end

  it "should guess the namespace directory from a project name" do
    expect(subject.namespace_path_of('foo-bar')).to eq('foo/bar')
  end
end
