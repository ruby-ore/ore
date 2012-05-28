require 'rspec'

require 'ore/options'

shared_examples "a gemspec" do
  it "should have a name" do
    subject.name.should == name
  end

  it "should not contain a version by default" do
    subject.version.version.should == Ore::Options::DEFAULT_VERSION
  end

  it "should a dummy summary" do
    subject.summary.should == Ore::Options::DEFAULT_SUMMARY
  end

  it "should a dummy description" do
    subject.description.should == Ore::Options::DEFAULT_DESCRIPTION
  end

  it "should have a license" do
    subject.license.should == Ore::Options::DEFAULT_LICENSE
  end

  it "should have authors" do
    subject.authors.should_not be_empty
  end

  it "should have a dummy homepage" do
    subject.homepage.should_not be_empty
  end
end
