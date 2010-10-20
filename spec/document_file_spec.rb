require 'spec_helper'
require 'helpers/files'

require 'ore/document_file'

describe DocumentFile do
  include Helpers::Files

  subject { DocumentFile.new(file('.document')) }

  it "should parse the file globs from a .document file" do
    subject.file_globs.to_a.should =~ %w[
      lib/**/*.rb
      bin/*
    ]
  end

  it "should parse the extra-file globs from a .document file" do
    subject.extra_file_globs.to_a.should =~ %w[
      ChangeLog.md
      COPYING.txt
    ]
  end

  it "should not consume the - separator" do
    subject.file_globs.should_not include('-')
    subject.extra_file_globs.should_not include('-')
  end
end
