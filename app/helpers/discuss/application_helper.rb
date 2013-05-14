module Discuss
  module ApplicationHelper
    def message_person(mailbox_name, message)
      mailbox_name == 'inbox' ? message.sender : message.recipient_list.join(', ')
    end
  end
end
