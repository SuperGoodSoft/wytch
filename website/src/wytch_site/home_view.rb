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
        
        section do
          h2 { "API Documentation" }
          ul do
            api_pages.each do |page|
              li { a(href: page.path) { page.metadata[:title] } }
            end
          end
        end
      end
    end
    
    private
    
    def api_pages
      Wytch.site.pages.values
        .select { |p| p.path.start_with?('/api/') }
        .sort_by { |p| p.metadata[:title] }
    end
  end
end
