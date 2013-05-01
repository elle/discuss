module Discuss
  module ApplicationHelper
    # [e] for lack of a better name
    # also happy to rethink this method
    def message_person(mailbox_name, message)
      case mailbox_name
      when 'inbox'  then message.sender.user
      when 'outbox' then recipients_titles(message.recipients)
      when 'drafts' then message.recipients.any? ? recipients_titles(message.recipients) : 'Draft'
      when 'trash'  then message.sent? ? recipients_titles(message.recipients) : message.sender.user
      else
        message.user
      end
    end

    def recipients_titles(recps)
      recps.collect { |m| m.user.title }.join(', ')
    end
  end
end
