module Discuss
  class Message < ActiveRecord::Base
    self.table_name = 'messages'

    belongs_to :sender, class_name: :discuss_user
    has_many :message_users
    has_many :recipients, through: :message_users, source: :discuss_user

    validates :body, presence: true
  end
end
