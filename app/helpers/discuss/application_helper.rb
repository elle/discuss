module Discuss
  module ApplicationHelper
    # [e] for lack of a better name
    def message_person(mailbox_name, message)
      mailbox_name == 'inbox' ? message.sender : recipients_string(message.recipient_list)
    end

    def recipients_string(users)
      users.join(', ')
    end
  end
end
