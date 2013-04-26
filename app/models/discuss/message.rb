module Discuss
  class Message < ActiveRecord::Base
    self.table_name = 'messages'

    has_ancestry

    belongs_to :discuss_user
    alias_method :user, :discuss_user

    validates :body, :discuss_user_id, presence: true

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

    scope :inbox,  lambda { |user| received.where(user_id: user.id) }
    scope :sent,   lambda { |user| sent.where(user_id: user.id)     }
    scope :drafts, lambda { |user| active.draft.where(user_id: user.id) }
    scope :trash,  lambda { |user| trashed.where(user_id: user.id)  }

    #before_save :set_draft

    def recipients
      children
    end

    def recipients= users
      # todo
    end

    def active?
      Message.active.include?(self)
    end

    def send!
      self.sent_at = Time.now
      save
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

    def unsent?
      !sent?
    end
    alias_method :draft?, :unsent?

    def delivered?
      # todo
    end


    private
    # sent_at is nil by default. so, this is just a safeguard in case there are no recipients
    def set_draft
      self.sent_at = nil if recipients.empty?
      true
    end
  end
end
