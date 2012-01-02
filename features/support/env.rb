require 'cucumber/rails'

Capybara.default_selector = :css

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

require 'mocha'

World(Mocha::Standalone)

Before do
  mocha_setup
end

After do
  begin
    mocha_verify
  ensure
    mocha_teardown
  end
end
