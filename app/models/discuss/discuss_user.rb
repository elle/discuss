module Discuss
  class DiscussUser < ActiveRecord::Base
    self.table_name = 'discuss_users'

    has_many :message_users
    has_many :messages, through: :message_users
  end
end
