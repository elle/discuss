# [e] should really be a state machine,
# but howto when message attributes is split between 2 models,
# one for sent messages (Message) and one for received messages (MessageRecipient)
#
# Also, should be split into 2 classes:
# 1. message actions
# 2. mailbox, which should handle stuff like empty_trash! which really should not belong on a message instance

module Discuss
  class Mailbox
    attr_accessor :message, :user

    def initialize(message, user)
      @message = message
      @user = user
    end


    def sender?
      message.sender == user
    end

    def recipient?
      !sender?
    end

    def recieved_message
      user.message_recipients.find_by(message: message)
    end

    def trash!
      message.trash! if sender?
      recieved_message.trash! if recipient?
    end

    def delete!
      message.delete!
      recieved_message.delete! if recipient?
    end

    def read!
      recieved_message.read! if recipient?
    end

    def empty_trash!
      Message.trash(user).each { |m| Mailbox.new(m, user).delete! }
    end
  end
end
