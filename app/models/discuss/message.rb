require 'thread'

module Discuss
  class Message < ActiveRecord::Base
    has_ancestry

    attr_accessor :draft
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

    def sender
      sent? ? user : parent.user
    end

    def recipients
      children
    end

    def recipients= users
      users.each { |u| draft_recipient_ids << u.id }
    end

    def recipient_list
      draft_recipient_ids.reject(&:blank?).map {|id| User.find id}
    end

    def send!
      lock.synchronize do
        Discuss::MessageSender.new(self).run unless draft?
      end
    end

    def reply! options={}
      if parent
        reply = children.create!(subject: options.fetch(:subject, subject),
                                 body: options.fetch(:body, nil),
                                 user: user,
                                 recipients: [parent.user])
        reply.send!
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

    %w[sent received trashed deleted read].each do |act|
      define_method "#{act}?" do
        self.send(:"#{act}_at").present?
      end
    end

    def uneditable?
      !editable?
    end

    def unsent?
      !sent?
    end

    # passed in from the compose form
    def draft?
      self.draft == '1'
    end

    def sent_date
      sent_at || received_at
    end

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
