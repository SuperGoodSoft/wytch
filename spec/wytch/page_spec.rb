RSpec.describe Wytch::Page do
  before do
    Wytch.configure do |site|
      site.content_dir = File.expand_path("../fixtures", __dir__)
    end
  end

  let(:page) { described_class.new(file_path: "dsl.rb") }

  describe "#initialize" do
    it "executes the file in the context of the page" do
      expect(page.metadata).to include title: "Computers bend to my will"
    end
  end

  describe "#render" do
    let(:view_class) {
      Class.new do
        def initialize(_)
        end

        def call
          "<html>rendered</html>"
        end
      end
    }
    let(:page) { described_class.new(file_path: "dsl.rb") }

    before do
      page.view(view_class)
    end

    it "delegates to the view" do
      page.render

      expect(page.render).to eq "<html>rendered</html>"
    end
  end

  describe "#path" do
    subject { page.path }

    context "when the page is an index" do
      let(:page) {
        described_class.new(file_path: "index.rb")
      }

      it { is_expected.to eq "/" }
    end

    context "when the page is not an index" do
      let(:page) {
        described_class.new(file_path: "about.rb")
      }

      it { is_expected.to eq "/about" }
    end
  end

  describe "#build_path" do
    subject { page.build_path }

    context "when the page is an index" do
      let(:page) {
        described_class.new(file_path: "index.rb")
      }

      it { is_expected.to eq "index/index.html" }
    end

    context "when the page is not an index" do
      let(:page) {
        described_class.new(file_path: "about.rb")
      }

      it { is_expected.to eq "about/index.html" }
    end
  end

  describe "DSL"
end
