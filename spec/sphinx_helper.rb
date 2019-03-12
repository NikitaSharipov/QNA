require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  #befor all
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    #ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    # Default to transaction strategy for all specs
    DatabaseCleaner.strategy = :truncation

    ThinkingSphinx::Test.index
  end

  #config.before(:each, :sphinx => true) do
  #  # For tests tagged with Sphinx, use deletion (or truncation)
  #  DatabaseCleaner.strategy = :deletion
  #end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
