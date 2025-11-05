RSpec.describe Wytch::Page do
  let(:page) { described_class.new }
  let(:dsl_file_path) { File.expand_path("../support/dsl.rb", __dir__) }

  describe "#load_file" do
    it "executes the file in the context of the page" do
      page.load_file dsl_file_path

      expect(page.metadata).to include title: "Computers bend to my will"
    end
  end

  describe "#render"

  describe "DSL"
end
