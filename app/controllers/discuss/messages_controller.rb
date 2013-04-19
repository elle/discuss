require_dependency 'discuss/application_controller'

module Discuss
  class MessagesController < ApplicationController
    def inbox
      #@messages = Message.inbox(current_user)
    end

    def sent
      #@sent = Message.sent(current_user)
    end

    def trash
    end
  end
end
