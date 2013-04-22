# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/spec'
require 'debugger'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rails/test_help'

require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir['#{File.dirname(__FILE__)}/support/**/*.rb'].each { |f| require f }

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before(:each) { DatabaseCleaner.start }
  after(:each) { DatabaseCleaner.clean }

  class << self
    alias context describe
  end
end
