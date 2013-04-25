module Discuss
  class MessageRecipient < ActiveRecord::Base
    self.table_name = 'message_recipients'

    include Trashable

    belongs_to :message
    belongs_to :discuss_user

    scope :read,       -> { where('read_at is not NULL') }
    scope :unread,     -> { where('read_at is NULL') }

    def read!
      update(read_at: Time.now)
    end
  end
end
