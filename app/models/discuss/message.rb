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

    scope :read,   lambda { |user| joins(:message_recipients).where('message_recipients.read_at is not NULL and
                                                                     message_recipients.discuss_user_id = ?', user.id) }

    scope :trashed_sent,     lambda { |user| trashed.where(sender_id: user.id) }
    scope :trashed_received, lambda { |user| joins(:message_recipients).where('message_recipients.trashed_at is not NULL and
                                                                               message_recipients.deleted_at is NULL and
                                                                               message_recipients.discuss_user_id = ?', user.id) }

    before_save :set_draft

    def self.trash user
      Message.trashed_sent(user) + Message.trashed_received(user)
    end

    def sent?
      sent_at.present?
    end

    def unsent?
      !sent?
    end

    def send!
      self.attributes = { draft: false, sent_at: Time.now }
      save
    end

    private
    # draft is true by default. so, this is just a safeguard in case there are no recipients
    def set_draft
      self.draft = (unsent? || recipients.empty?)
      true
    end
  end
end
