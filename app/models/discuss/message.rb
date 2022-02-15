require 'thread'

module Discuss
  # You can override the inbox scope like so:
  #
  #     Discuss::Message.inbox_scope = -> (messages, user) {
  #       messages.by_user(user).active.received.my_filter
  #     }
  #
  # It defaults to:
  #
  #     -> (messages, user) {
  #       messages.by_user(user).active.received
  #     }
  #
  class Message < Discuss.model_base
    has_ancestry

    attr_accessor :draft
    serialize :draft_recipient_ids, Array

    belongs_to :user, polymorphic: true

    validates :body, :user, presence: true
    validate :lock_down_attributes, on: :update

    scope :ordered,      -> { order('created_at desc') }
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

    scope :by_user, -> (user) { where(user: user) }
    scope :inbox,   -> (user) { ::Discuss::Message.inbox_scope(self, user) }
    scope :outbox,  -> (user) { by_user(user).active.sent }
    scope :drafts,  -> (user) { by_user(user).active.draft.not_received }
    scope :trash,   -> (user) { by_user(user).trashed.not_deleted }

    scope :read,    -> (user) { by_user(user).where('read_at is not NULL').received }
    scope :unread,  -> (user) { by_user(user).where('read_at is NULL').received }

    class << self
      attr_accessor :inbox_scope
    end

    # Allow this to be overridden
    self.inbox_scope = -> (messages, user) { messages.by_user(user).active.received }

    def active?
      !trashed? && !deleted?
    end

    def sender
      if sent?
        user
      else
        parent ? parent.user : user
      end
    end

    def recipients
      if sent?
        children.collect(&:user)
      elsif parent.present?
        parent.recipients
      else
        draft_recipients
      end
    end

    def draft_recipients
      self.draft_recipient_ids.map { |id| Discuss::RecipientSerializer.from_hash(id).recipient }
    end

    def draft_recipients= recipients
      self.draft_recipient_ids = recipients.map { |r| Discuss::RecipientSerializer.new(r).to_hash }
    end
    alias_method :recipients=, :draft_recipients=

    def mailbox
      case
      when sent? then :outbox
      when received? then :inbox
      when !new_record? && unsent? then :drafts
      when trashed? then :trash
      else
        :compose
      end
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
                                 draft_recipients: [parent.user],
                                 draft: draft)
        reply.send!
      end
    end

    def receive!
      update(received_at: Time.zone.now)
    end

    def read!
      update(read_at: Time.zone.now) unless self.read_at.present?
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

    def unread?
      !read?
    end

    def uneditable?
      !editable?
    end

    def unsent?
      !sent?
    end

    # passed in from the compose form
    def draft?
      self.draft == true || self.draft == '1'
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
