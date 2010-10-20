require 'spec_helper'
require 'helpers/files'

require 'ore/versions/version_file'

describe Versions::VersionFile do
  include Helpers::Files

  subject { Versions::VersionFile }

  it "should load and parse the version string from a VERSION file" do
    v = subject.load(file('VERSION'))

    v.major.should == 1
    v.minor.should == 2
    v.patch.should == 3
    v.build.should be_nil
  end

  it "should load and parse the version numbers from a VERSION.yml file" do
    v = subject.load(file('VERSION.yml'))

    v.major.should == 1
    v.minor.should == 2
    v.patch.should == 3
    v.build.should be_nil
  end
end
