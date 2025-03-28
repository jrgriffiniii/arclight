# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
ENV['REPOSITORY_FILE'] ||= 'spec/fixtures/config/repositories.yml'
SPEC_ROOT = Pathname.new(__dir__)

require 'simplecov'
SimpleCov.start do
  add_filter '/.internal_test_app/'
  add_filter '/spec/'
end

require 'engine_cart'
EngineCart.load_application!

require 'rspec/rails'

require 'selenium-webdriver'
require 'webdrivers'

Capybara.javascript_driver = :selenium_chrome_headless

Capybara.default_max_wait_time = 15 # our ajax responses are sometimes slow

Capybara.enable_aria_label = true

require 'arclight'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Provide a custom matcher that makes it easier to deal with pretty-printed
# XML

require 'rspec/expectations'

def condense_whitespace(str)
  str.gsub(/[\n\s]+/, ' ').strip
end

def equal_modulo_whitespace(string1, string2)
  condense_whitespace(string1) == condense_whitespace(string2)
end

RSpec::Matchers.define :eq_ignoring_whitespace do |expected|
  match do |actual|
    condense_whitespace(expected) == condense_whitespace(actual)
  end
end

RSpec::Matchers.define :include_ignoring_whitespace do |expected|
  ex = condense_whitespace(expected)
  match do |actual|
    actual.any? { |act| condense_whitespace(act) == ex }
  end
end

RSpec::Matchers.define :equal_array_ignoring_whitespace do |expected|
  match do |actual|
    actual.map { |act| condense_whitespace(act) } == expected.map { |ex| condense_whitespace(ex) }
  end
end
