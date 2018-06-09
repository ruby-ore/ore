require 'pathname'
require 'spec_helper'
require 'helpers/common'
require 'ore/cli'

describe CLI do
  include Helpers::Common

  let(:cli)           { described_class.new }
  let(:fixtures_dir)  { Pathname.new('../fixtures').expand_path(__FILE__) }
  let(:repo)          { fixtures_dir.join('mock_template.git') }
  let(:url)           { "file://#{repo.cleanpath}" }
  let(:templates_dir) { from_root_path('templates') }

  before(:each) do
    stub_const('Ore::Config::TEMPLATES_DIR', templates_dir)
    allow(cli).to receive(:exit).and_raise('Ore::CLI exited unexpectedly')
  end

  describe "#install" do
    before(:all) do
      skip 'git is not installed on your system' unless have_git?
    end

    context "when given an optional template name" do
      it "installs the template to a subdirectory of that name" do
        cli.install(url, 'mockery')
        expect(templates_dir).to have_directory('mockery')
      end

      context "with one or more directory separators" do
        it "installs the template to the basename of that name" do
          expect(cli).to receive(:say).with(/^Truncating template name/, :yellow)
          cli.install(url, 'mock/ing/bird')
          expect(templates_dir).to have_directory('bird')
        end
      end
    end

    context "when the optional template name is omitted" do
      it "installs the template to the basename of the URI" do
        cli.install(url)
        expect(templates_dir).to have_directory('mock_template')
      end
    end

    after(:all) do
      cleanup! if have_git?
    end
  end
end
