require 'spec_helper'
require 'ore/dependency'

describe Dependency do
  subject { Dependency }

  describe "parse" do
    it "should parse a dependency string with only a name" do
      dep = subject.parse('foo')

      dep.name.should == 'foo'
      dep.versions.should be_empty
    end

    it "should parse a dependency with a version" do
      dep = subject.parse('foo ~> 1.2.3')

      dep.name.should == 'foo'
      dep.versions.should == ['~> 1.2.3']
    end
  end

  describe "parse_versions" do
    it "should parse a single version" do
      dep = subject.parse_versions('foo', '~> 1.2.3')

      dep.versions.should == ['~> 1.2.3']
    end

    it "should parse multiple versions" do
      dep = subject.parse_versions('foo', '~> 1.2.3, >= 1.4.0')

      dep.versions.should == ['~> 1.2.3', '>= 1.4.0']
    end
  end
end
