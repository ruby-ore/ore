require 'spec_helper'
require 'ore/version'

describe Ore do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
end
