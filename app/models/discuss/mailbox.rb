# @mailbox ||= Mailbox.new(current_user)

module Discuss
  class Mailbox
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def inbox
      Message.inbox(user)
    end

    def outbox
      Message.outbox(user)
    end

    def drafts
      Message.drafts(user)
    end

    def trash
      Message.trash(user)
    end

    def empty_trash!
      trash.each { |message| message.delete! }
    end
  end
end


