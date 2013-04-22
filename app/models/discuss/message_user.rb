module Discuss
  class MessageUser < ActiveRecord::Base
    self.table_name = 'message_users'

    belongs_to :message
    belongs_to :discuss_user
  end
end
