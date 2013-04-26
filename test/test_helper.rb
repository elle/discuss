# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'capybara/rails'
require 'debugger'

require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir['#{File.dirname(__FILE__)}/support/**/*.rb'].each { |f| require f }

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before(:each) do
    DatabaseCleaner.start
    create_users
  end

  after(:each) { DatabaseCleaner.clean }

  class << self
    alias context describe
  end
end

class FeatureTest < MiniTest::Spec
  include Rails.application.routes.url_helpers # to get url_helpers working
  include Capybara::DSL # to get capybara working
end


def create_users
  @sender =     Discuss::DiscussUser.create!(email: 'teacher@school.com', user_type: 'teacher', user_id: 4)
  @recipient =  Discuss::DiscussUser.create!(email: 'bart@student.com', user_type: 'student', user_id: 1)
  @lisa =       Discuss::DiscussUser.create!(email: 'lisa@student.com', user_type: 'student', user_id: 2)
end
