# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'minitest/autorun'
require 'minitest/spec'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }