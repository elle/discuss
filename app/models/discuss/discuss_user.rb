module Discuss
  class DiscussUser < ActiveRecord::Base
    self.table_name = 'discuss_users'

    has_many :message_users
    has_many :received_messages, through: :message_users, source: :messages
    has_many :sent_messages, class_name: :messages

    validates :email, :user_id, presence: true
  end
end
