# frozen_string_literal: true

module WytchSite
  class ApiClassView < Phlex::HTML
    def initialize(page)
      @page = page
      @klass = @page.yard_object
    end

    def view_template
      render Layout.new(@page) do
        article do
          header do
            h1 { @klass.path }
            p(class: "summary") { @klass.docstring.summary } unless @klass.docstring.summary.empty?
          end

          unless @klass.docstring.to_s.empty?
            section(class: "description") do
              h2 { "Description" }
              div { unsafe_raw markdown_to_html(@klass.docstring.to_s) }
            end
          end

          # Public methods
          public_methods = @klass.meths(visibility: :public).reject { |m| m.name == :initialize }
          if public_methods.any?
            section(class: "methods") do
              h2 { "Methods" }
              public_methods.each do |method|
                render_method(method)
              end
            end
          end
        end
      end
    end

    private

    def render_method(method)
      article(class: "method", id: method.name) do
        h3 { code { method.signature } }
        
        unless method.docstring.to_s.empty?
          div(class: "method-description") do
            unsafe_raw markdown_to_html(method.docstring.to_s)
          end
        end

        # Parameters
        param_tags = method.tags.select { |t| t.tag_name == "param" }
        if param_tags.any?
          dl(class: "parameters") do
            dt { "Parameters:" }
            param_tags.each do |tag|
              dd do
                code { tag.name }
                span { " (#{tag.types.join(', ')})" } if tag.types
                plain " — #{tag.text}" if tag.text
              end
            end
          end
        end

        # Returns
        return_tags = method.tags.select { |t| t.tag_name == "return" }
        if return_tags.any?
          dl(class: "returns") do
            dt { "Returns:" }
            return_tags.each do |tag|
              dd do
                span { "(#{tag.types.join(', ')})" } if tag.types
                plain " — #{tag.text}" if tag.text
              end
            end
          end
        end
      end
    end

    def markdown_to_html(text)
      # Simple markdown rendering - just handle basic formatting
      text.gsub(/`([^`]+)`/, '<code>\1</code>')
          .gsub(/\*\*([^*]+)\*\*/, '<strong>\1</strong>')
          .gsub(/\n\n/, '</p><p>')
          .then { |s| "<p>#{s}</p>" }
    end
  end
end
