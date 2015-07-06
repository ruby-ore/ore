require 'spec_helper'
require 'ore/template/helpers/textile'

describe Ore::Template::Helpers::Textile do
  subject do
    Object.new.extend described_class
  end

  describe "#link_to" do
    let(:text) { "foo bar" }
    let(:url)  { "https://example.com/foo/bar" }

    it "should return a link with the text and url" do
      expect(subject.link_to(text,url)).to be == %{"#{text}":#{url}}
    end
  end

  describe "#image" do
    let(:url) { "https://example.com/foo/bar.png" }

    context "with alt text" do
      let(:alt) { "foo bar" }

      it "should return a link with the alt text and url" do
        expect(subject.image(url,alt)).to be == "!#{url}(#{alt})!"
      end
    end

    context "without alt text" do
      it "should return a link with the alt text and url" do
        expect(subject.image(url)).to be == "!#{url}!"
      end
    end
  end

  describe "#h1" do
    let(:title) { "Foo Bar" }

    it "should return a h1 header" do
      expect(subject.h1(title)).to be == "h1. #{title}"
    end
  end

  describe "#h2" do
    let(:title) { "Foo Bar" }

    it "should return a h2 header" do
      expect(subject.h2(title)).to be == "h2. #{title}"
    end
  end

  describe "#h3" do
    let(:title) { "Foo Bar" }

    it "should return a h3 header" do
      expect(subject.h3(title)).to be == "h3. #{title}"
    end
  end

  describe "#h4" do
    let(:title) { "Foo Bar" }

    it "should return a h4 header" do
      expect(subject.h4(title)).to be == "h4. #{title}"
    end
  end

  describe "#pre" do
    context "with a single line" do
      let(:code) { %{puts "hello world"} }

      it "should prepend bc." do
        expect(subject.pre(code)).to be == "bc. #{code}"
      end
    end

    context "with multiple lines" do
      let(:lines) do
        [
          %{puts "hello"},
          %{},
          %{puts "world"}
        ]
      end
      let(:code) { lines.join($/) }

      it "should prepend bc.." do
        expect(subject.pre(code)).to be == "bc.. #{code}"
      end
    end
  end
end
