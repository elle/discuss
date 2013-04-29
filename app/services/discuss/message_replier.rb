class Discuss::MessageReplier
  attr_reader :message, :subject, :body

  delegate :user,   to: :message

  def initialize options
    @message = options.fetch(:message)
    @subject = options.fetch(:subject, message.subject)
    @body = options.fetch(:body)
  end

  def run
    reply! if parent_message
  end

  def parent_message
    message.parent
  end

  def sender
    parent_message.user
  end

  private
  # We creating a new message here because the body is different
  # And then creating a second message when it is delivered
  def reply!
    reply = user.messages.create(subject: subject, body: body, recipients: [sender])
    reply.send!
  end
end
