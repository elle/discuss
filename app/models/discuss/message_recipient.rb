module Discuss
  class MessageRecipient < ActiveRecord::Base
    self.table_name = 'message_recipients'

    include Trashable

    belongs_to :message
    belongs_to :discuss_user
  end
end
