# @mailbox ||= Mailbox.new(current_user)

module Discuss
  class Mailbox
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    [:inbox, :outbox, :drafts, :trash].each do |mailbox|
      define_method mailbox do
        Message.ordered.send(mailbox, user)
      end
    end

    def empty_trash!
      trash.each { |message| message.delete! }
    end
  end
end


