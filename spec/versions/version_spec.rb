require 'spec_helper'
require 'ore/versions/version'

describe Ore::Versions::Version do
  subject { Ore::Versions::Version }

  describe "new" do
    let(:stable) { subject.new(1,2,3) }
    let(:beta) { subject.new(1,2,3,'beta4') }

    it "should default the major, minor and patch numbers to 0" do
      v = subject.new(nil,nil,nil)

      v.major.should == 0
      v.minor.should == 0
      v.patch.should == 0
    end

    it "should default the build string to nil" do
      stable.build.should == nil
    end

    it "should construct a version string from the numbers" do
      stable.version.should == '1.2.3'
    end

    it "should append the build string to the version" do
      beta.version.should == '1.2.3.beta4'
    end
  end

  describe "parse" do
    let(:stable) { '1.2.3' }
    let(:beta) { '1.2.3.beta4' }

    it "should parse the major, minor and patch version numbers" do
      v = subject.parse(stable)

      v.major.should == 1
      v.minor.should == 2
      v.patch.should == 3
    end

    it "should parse the build string if given" do
      v = subject.parse(beta)

      v.major.should == 1
      v.minor.should == 2
      v.patch.should == 3
      v.build.should == 'beta4'
    end
  end
end
