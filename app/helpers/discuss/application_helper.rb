module Discuss
  module ApplicationHelper
    def message_person(mailbox_name, message)
      mailbox_name == 'inbox' ? message.sender : message.recipients.join(', ')
    end

    def markdown(text)
      html = Redcarpet::Render::Safe.new(no_images: true, no_styles: true, hard_wrap: true)
      markdown = ::Redcarpet::Markdown.new(html, footnotes: true)
      markdown.render(text).html_safe
    end
  end
end
