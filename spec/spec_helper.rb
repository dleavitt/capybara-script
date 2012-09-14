require 'bundler/setup'
require "pry"
require "ap"
require 'capybara'
require 'capybara/webkit'
require 'capybara/script'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Capybara.run_server = false

RSpec.configure do |config|
  
end
