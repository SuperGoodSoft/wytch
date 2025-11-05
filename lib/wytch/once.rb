# frozen_string_literal: true

module Wytch
  class Once
    def initialize(&block)
      @block = block
      @mutex = Mutex.new
    end

    def call
      @mutex&.synchronize do
        return unless @mutex

        @block.call

        @mutex = nil
      end
    end
  end
end
