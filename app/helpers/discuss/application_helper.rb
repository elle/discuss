module Discuss
  module ApplicationHelper
    def message_person(mailbox_name, message)
      mailbox_name == 'inbox' ? message.sender : message.recipients.join(', ')
    end

    def markdown(text)
      Redcarpet.new(text).to_html.html_safe
    end
  end
end
