class Discuss::MessageSender
  attr_reader :message, :recipients

  delegate :body, to: :message
  delegate :subject, to: :message

  def initialize message
    @message = message
    @recipients = message.draft_recipients
  end

  def run
    deliver!
  end

  private
  def set_as_sent
    message.update_column(:sent_at, Time.zone.now)
    message.update_column(:editable, false)
  end

  def deliver!
    if recipients.any? && message.unsent?
      set_as_sent
      recipients.each { |recipient| deliver_to recipient }
    end
  end

  def deliver_to recipient
    attrs = {subject: subject, body: body, user: recipient, received_at: Time.zone.now, editable: false }
    message.children.create(attrs)
  end
end
