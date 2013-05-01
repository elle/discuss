require 'thread'

module Discuss
  class Message < ActiveRecord::Base
    self.table_name = 'messages'

    has_ancestry

    serialize :draft_recipient_ids, Array

    belongs_to :user

    validates :body, :user_id, presence: true
    validate :lock_down_attributes, on: :update


    scope :ordered,      -> { order('created_at asc') }
    scope :active,       -> { not_trashed.not_deleted }

    scope :draft,        -> { where('sent_at is NULL') }
    scope :not_draft,    -> { where('sent_at is not NULL')  }

    scope :sent,         -> { where('sent_at is not NULL') }
    scope :unsent,       -> { where('sent_at is NULL')  }

    scope :received,     -> { where('received_at is not NULL') }
    scope :not_received, -> { where('received_at is NULL') }

    scope :trashed,      -> { where('trashed_at is not NULL') }
    scope :not_trashed,  -> { where('trashed_at is NULL') }

    scope :deleted,      -> { where('deleted_at is not NULL') }
    scope :not_deleted,  -> { where('deleted_at is NULL') }

    scope :by_user, lambda { |user| where(user_id: user.id) }
    scope :inbox,   lambda { |user| by_user(user).active.received }
    scope :outbox,  lambda { |user| by_user(user).active.sent }
    scope :drafts,  lambda { |user| by_user(user).active.draft.not_received }
    scope :trash,   lambda { |user| by_user(user).trashed.not_deleted }


    def active?
      !trashed? && !deleted?
    end

    def recipients
      children
    end

    def recipient_list
      draft_recipient_ids.map {|id| User.find id}.reject(&:blank?)
    end

    def sender
      sent? ? user : parent.user
    end

    def recipients= users
      users.each { |u| draft_recipient_ids << u.id }
    end

    def send!
      lock.synchronize do
        if draft_recipient_ids.any? && unsent?
          update_column(:sent_at, Time.zone.now)
          toggle(:editable)
          Discuss::MessageSender.new(self).run
        end
      end
    end

    def receive!
      update(received_at: Time.zone.now)
    end

    def read!
      update(read_at: Time.zone.now)
    end

    def trash!
      update(trashed_at: Time.zone.now)
    end

    def delete!
      update(deleted_at: Time.zone.now)
    end

    def reply! options={}
      Discuss::MessageReplier.new(options.merge(message: self)).run
    end

    %w[sent received trashed deleted read].each do |act|
      define_method "#{act}?" do
        self.send(:"#{act}_at").present?
      end
    end

    def unsent?
      !sent?
    end
    alias_method :draft?, :unsent?

    private
    def lock_down_attributes
      return if editable?
      errors.add(:base, 'Cannot edit') unless deleted_at_changed? || trashed_at_changed? || read_at_changed?
    end

    def lock
      @lock ||= Mutex.new
    end
  end
end
