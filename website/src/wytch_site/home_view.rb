# frozen_string_literal: true

module WytchSite
  class HomeView < Phlex::HTML
    def initialize(page)
      @page = page
    end

    def view_template
      render Layout.new(@page) do
        h1 { @page.metadata[:title] }
        p { @page.metadata[:description] }
      end
    end
  end
end
