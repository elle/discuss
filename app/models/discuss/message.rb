module Discuss
  class Message < ActiveRecord::Base
    self.table_name = 'messages'

    belongs_to :sender, class_name: 'DiscussUser'
    has_many :message_users
    has_many :recipients, through: :message_users, source: :discuss_user

    validates :body, :sender_id, presence: true

    scope :draft,   -> { where(draft: true) }
    scope :trashed, -> { where(draft: true) }
    scope :deleted, -> { where(draft: true) }

    scope :inbox, lambda { |user| joins(:message_users).where('message_users.discuss_user_id =?', user.id) }
    scope :sent,  lambda { |user| where(sender_id: user.id) }
    scope :trash, lambda { |user| where(sender_id: user.id) }

    before_save :set_draft

    def self.drafts(user)
      Message.sent(user).draft
    end

    def delete
      update(deleted: true)
    end

    private
    def set_draft
      self.draft = true unless recipients.any?
    end
  end
end
