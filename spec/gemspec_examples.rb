require 'rspec'

require 'ore/options'

shared_examples "a gemspec" do
  it "should have a name" do
    expect(subject.name).to eq(@name)
  end

  it "should not contain a version by default" do
    expect(subject.version.version).to eq(Ore::Options::DEFAULT_VERSION)
  end

  it "should a dummy summary" do
    expect(subject.summary).to eq(Ore::Options::DEFAULT_SUMMARY)
  end

  it "should a dummy description" do
    expect(subject.description).to eq(Ore::Options::DEFAULT_DESCRIPTION)
  end

  it "should have a license" do
    expect(subject.license).to be == 'MIT'
  end

  it "should have authors" do
    expect(subject.authors).not_to be_empty
  end

  it "should have a dummy homepage" do
    expect(subject.homepage).not_to be_empty
  end
end
