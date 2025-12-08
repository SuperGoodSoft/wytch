# frozen_string_literal: true

require 'yard'

module WytchSite
  class Page < Wytch::Page
    def yard_object
      return nil unless @metadata[:yard_path]
      
      # Parse YARD if registry is empty
      if YARD::Registry.all.empty?
        YARD.parse(File.expand_path('../../../lib/**/*.rb', __dir__))
      end
      
      YARD::Registry.at(@metadata[:yard_path])
    end
  end
end
