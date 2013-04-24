module Discuss
  class Message < ActiveRecord::Base
    self.table_name = 'messages'

    include Trashable

    belongs_to :sender, class_name: 'DiscussUser'
    has_many :message_recipients
    has_many :recipients, through: :message_recipients, source: :discuss_user

    validates :body, :sender_id, presence: true

    scope :ordered,     -> { order('created_at asc') }

    scope :draft,       -> { where(draft: true) }
    scope :not_draft,   -> { where(draft: false) }

    scope :inbox,  lambda { |user| joins(:message_recipients).where('message_recipients.discuss_user_id = ?', user.id) }
    scope :sent,   lambda { |user| active.where(sender_id: user.id) }
    scope :drafts, lambda { |user| draft.not_trashed.not_deleted.where(sender_id: user.id) }

    scope :trashed_sent,     lambda { |user| trashed.where(sender_id: user.id) }
    scope :trashed_received, lambda { |user| joins(:message_recipients).where('message_recipients.trashed_at is not NULL and message_recipients.discuss_user_id = ?', user.id) }

    before_save :set_draft

    def self.trash user
      Message.trashed_sent(user) + Message.trashed_received(user)
    end

    def draft!
      update(draft: true)
    end

    private
    def set_draft
      self.draft = true unless recipients.any?
    end
  end
end
