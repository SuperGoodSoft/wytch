# frozen_string_literal: true

module Wytch
  # A thread-safe utility for executing a block exactly once.
  #
  # Once ensures that a given block of code is executed only one time,
  # even when called from multiple threads. After the first execution,
  # subsequent calls are no-ops.
  #
  # @example
  #   setup = Once.new { puts "Initializing..." }
  #   setup.call  # prints "Initializing..."
  #   setup.call  # does nothing
  #   setup.call  # does nothing
  class Once
    # Creates a new Once instance with the given block.
    #
    # @yield the block to execute once
    def initialize(&block)
      @block = block
      @mutex = Mutex.new
    end

    # Executes the block if it hasn't been executed yet.
    #
    # Thread-safe: if multiple threads call this simultaneously,
    # only one will execute the block.
    #
    # @return [void]
    def call
      @mutex&.synchronize do
        return unless @mutex

        @block.call

        @mutex = nil
      end
    end
  end
end
