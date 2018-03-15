require "post_builder"
require "jekyll"

shared_examples "a document" do
  it "returns the author" do
    expect(subject.build[:author]).to eq "cromega"
  end

  it "returns the title" do
    expect(subject.build[:title]).to eq "Test"
  end

  it "returns the post body" do
    expect(subject.build[:content]).to eq "<p>TESTTEST</p>"
  end

  it "returns the post summary" do
    expect(subject.build[:summary]).to eq "<p>TEST</p>"
  end

  it "returns the post date in ISO8601 format" do
    expect(subject.build[:date]).to eq "2018-03-15"
  end

  it "returns the tags" do
    expect(subject.build[:tags]).to eq ["tag"]
  end

  it "returns the permalink" do
    expect(subject.build[:url]).to eq "/test.json"
  end
end

describe PostBuilder do
  describe "#build" do
    let(:post) { double(:post, content: "<p>TESTTEST</p>", data: meta) }
    context "when the document is a Jekyll::Document" do
      let(:meta) do
        {
          "author" => "cromega",
          "title" => "Test",
          "tags" => ["tag"],
          "date" => Time.new(2018, 03, 15, 01, 02, 03, "+00:00"),
          "permalink" => "/test.json",
          "excerpt" => double(content: "<p>TEST</p>")
        }
      end
      subject { described_class.new(post) }

      it_behaves_like "a document"
    end

    context "when the document is a Jekyll:DocumentDrop" do
      let(:meta) do
        {
          "author" => "cromega",
          "title" => "Test",
          "tags" => ["tag"],
          "date" => Time.new(2018, 03, 15, 01, 02, 03, "+00:00"),
          "permalink" => "/test.json",
          "excerpt" => "<p>TEST</p>"
        }
      end
      let(:drop) { Jekyll::Drops::DocumentDrop.new(post) }
      subject { described_class.new(drop) }

      it_behaves_like "a document"
    end
  end
end
