# frozen_string_literal: true

RSpec.describe Wytch::ContentLoader do
  before do
    Wytch.configure do |site|
      site.content_dir = File.expand_path("../fixtures", __dir__)
    end
  end

  after do
    Wytch.reset_site!
  end

  describe "#load_content" do
    it "loads pages from the content directory" do
      pages = described_class.new.load_content

      expect(pages.keys).to include("/", "/about", "/dsl")
    end

    context "with a custom page class" do
      let(:custom_page_class) {
        Class.new(Wytch::Page) do
          def custom_method
            "custom"
          end
        end
      }

      before do
        stub_const("CustomPage", custom_page_class)
        Wytch.site.page_class = "CustomPage"
      end

      it "uses the configured page class" do
        pages = described_class.new.load_content

        expect(pages["/"].class).to eq custom_page_class
      end

      it "pages have access to custom methods" do
        pages = described_class.new.load_content

        expect(pages["/"].custom_method).to eq "custom"
      end
    end
  end
end
