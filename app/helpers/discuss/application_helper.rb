module Discuss
  module ApplicationHelper
    def message_person(mailbox_name, message)
      mailbox_name == 'inbox' ? message.sender : message.recipients.join(', ')
    end

    def markdown(text)
      html = Redcarpet::Render::HTML.new(escape_html: true, safe_links_only: true, no_images: true)
      markdown = ::Redcarpet::Markdown.new(html)
      markdown.render(text).html_safe
    end
  end
end
