module Discuss
  class Message < ActiveRecord::Base
    self.table_name = 'messages'

    has_many :message_users
    has_many :recipients, through: :message_users, source: :discuss_user

    validates :body, presence: true
  end
end
