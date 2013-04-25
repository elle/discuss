module Discuss
  class DiscussUser < ActiveRecord::Base
    self.table_name = 'discuss_users'

    has_many :message_recipients
    has_many :received_messages, -> { where('sent_at is not NULL') }, through: :message_recipients, source: :message

    has_many :messages, foreign_key: :sender_id
    has_many :sent_messages, -> { where('sent_at is not NULL') }, class_name: 'Message', foreign_key: :sender_id
    has_many :draft_messages, -> { where('sent_at is NULL') }, class_name: 'Message', foreign_key: :sender_id


    validates :email, :user_id, presence: true

    def to_s
      name
    end

    def title
      "#{name} <#{email}>"
    end
  end
end
