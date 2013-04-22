module Discuss
  class DiscussUser < ActiveRecord::Base
    self.table_name = 'discuss_users'

    has_many :message_users
    has_many :received_messages, -> { where(draft: false) }, through: :message_users, source: :message
    has_many :sent_messages, -> { where(draft: false) }, class_name: 'Message', foreign_key: :sender_id

    validates :email, :user_id, presence: true
  end
end
