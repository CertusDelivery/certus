require 'capybara/rspec'

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.default_wait_time = 10

Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
  config.exact_options = true
end
