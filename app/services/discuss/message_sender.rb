class Discuss::MessageSender
  attr_reader :message, :subject, :body, :recipients

  delegate :sender, to: :message

  # when sending: users: message.recipient_list
  # when replying: users: message.sender
  def initialize options
    @message = options.fetch(:message)
    @subject = options.fetch(:subject, message.subject)
    @body = options.fetch(:body, message.body)
    @recipients = options.fetch(:recipients, message.recipient_list)
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
      recipients.each { |user| deliver_to user }
    end
  end

  def deliver_to user
    attrs = {subject: subject, body: body, user: user, received_at: Time.zone.now, editable: false }
    message.children.create(attrs)
  end
end
