# @mailbox ||= Mailbox.new(current_user)

module Discuss
  class Mailbox
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def inbox
    end

    def sent
    end

    def drafts
    end

    def trash
    end

    def empty_trash!
    end
  end
end


