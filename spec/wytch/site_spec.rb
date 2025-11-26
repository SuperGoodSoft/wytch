# frozen_string_literal: true

RSpec.describe Wytch::Site do
  describe "#page_class" do
    it "defaults to Wytch::Page" do
      site = described_class.new

      expect(site.page_class).to eq "Wytch::Page"
    end

    it "can be configured" do
      site = described_class.new
      site.page_class = "CustomPage"

      expect(site.page_class).to eq "CustomPage"
    end
  end
end
