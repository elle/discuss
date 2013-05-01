class Discuss::MessageSender
  attr_reader :message

  delegate :subject,              to: :message
  delegate :body,                 to: :message
  delegate :id,                   to: :message
  delegate :draft_recipient_ids,  to: :message

  def initialize message
    @message = message
  end

  def run
    deliver!
  end

  private
  def deliver!
    message.recipient_list.each do |user|
      deliver_to user
    end
  end

  def deliver_to user
    attrs = {subject: subject, body: body, parent_id: id, received_at: Time.zone.now, editable: false }
    user.messages.create(attrs)
  end
end
