# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'capybara/rails'

require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

Rails.backtrace_cleaner.remove_silencers!

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

module MiniTest
  class Spec
    before(:each) do
      DatabaseCleaner.start
      create_users
    end

    after(:each) { DatabaseCleaner.clean }

    class << self
      alias context describe
    end
  end
end

class FeatureTest < MiniTest::Spec
  include Rails.application.routes.url_helpers # to get url_helpers working
  include Capybara::DSL # to get capybara working

  before(:each) do
    create_users
    bypass_user
    bypass_recipients
  end

  after(:each) do
    restore_user
  end
end

def create_users
  @sender       = User.where(email: 'teacher@school.com', first_name: 'teacher').first_or_create
  @recipient    = User.where(email: 'bart@student.com', first_name: 'bart', last_name: 'simpsons').first_or_create
  @lisa         = User.where(email: 'lisa@student.com', first_name: 'lisa', last_name: 'simpsons').first_or_create
  @current_user = nil
end

def bypass_user
  current_user = @sender if @current_user == nil
  @old_user = Discuss::ApplicationController.instance_method(:discuss_current_user)
  Discuss::ApplicationController.send(:remove_method, :discuss_current_user)
  Discuss::ApplicationController.send(:define_method, :discuss_current_user) do
    current_user
  end
  @current_user = current_user
end

def restore_user
  Discuss::ApplicationController.send(:remove_method, :discuss_current_user)
  Discuss::ApplicationController.send(:define_method, :discuss_current_user, @old_user)
end

def bypass_recipients
  discuss_recipients = User.all.reject { |u| u == @current_user }
  Discuss::ApplicationController.send(:remove_method, :recipients)
  Discuss::ApplicationController.send(:define_method, :recipients) do
    discuss_recipients
  end
end
