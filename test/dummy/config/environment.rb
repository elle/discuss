# Load the Rails application.
require File.expand_path('../application', __FILE__)

::Discuss.maximum_message_body_chars = 1090

# Initialize the Rails application.
Rails.application.initialize!
