# frozen_string_literal: true

require "wytch"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    # Disable the old `should` syntax.
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed

  # FIXME: Configuration below this line will be the default in RSpec 4. Remove
  # it when we get there.
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
