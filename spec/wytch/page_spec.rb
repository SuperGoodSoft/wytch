RSpec.describe Wytch::Page do
  let(:page) { described_class.new(file_path: dsl_file_path) }
  let(:dsl_file_path) { File.expand_path("../fixtures/dsl.rb", __dir__) }

  describe "#initialize" do
    it "executes the file in the context of the page" do
      expect(page.metadata).to include title: "Computers bend to my will"
    end
  end

  describe "#render"

  describe "#path" do
    subject { page.path }

    context "when the page is an index" do
      let(:page) {
        described_class.new(file_path: File.expand_path("../fixtures/index.rb", __dir__))
      }

      it { is_expected.to eq "/" }
    end

    context "when the page is not an index" do
      let(:page) {
        described_class.new(file_path: File.expand_path("../fixtures/about.rb", __dir__))
      }

      it { is_expected.to eq "/about" }
    end
  end

  describe "DSL"
end
