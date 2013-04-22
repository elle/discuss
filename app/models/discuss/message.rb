module Discuss
  class Message < ActiveRecord::Base
    self.table_name = 'messages'

    belongs_to :sender, class_name: 'DiscussUser'
    has_many :message_users
    has_many :recipients, through: :message_users, source: :discuss_user

    validates :body, :sender_id, presence: true

    scope :ordered,     -> { order('created_at asc') }
    scope :draft,       -> { where(draft:   true) }
    scope :trashed,     -> { where(trashed: true) }
    scope :deleted,     -> { where(deleted: true) }
    scope :not_draft,   -> { where(draft:   false) }
    scope :not_trashed, -> { where(trashed: false) }
    scope :not_deleted, -> { where(deleted: false) }

    scope :active,  -> { not_draft.not_trashed.not_deleted }

    scope :inbox,  lambda { |user| joins(:message_users).where('message_users.discuss_user_id = ?', user.id) }
    scope :sent,   lambda { |user| active.where(sender_id: user.id) }
    scope :trash,  lambda { |user| trashed.where(sender_id: user.id) }
    scope :drafts, lambda { |user| draft.not_trashed.not_deleted.where(sender_id: user.id) }

    before_save :set_draft

    def delete
      update(deleted: true)
    end

    def active?
      Message.active.include?(self)
    end

    private
    def set_draft
      self.draft = true unless recipients.any?
    end
  end
end
