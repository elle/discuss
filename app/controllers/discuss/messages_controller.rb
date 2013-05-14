require_dependency 'discuss/application_controller'

module Discuss
  class MessagesController < ApplicationController
    before_action :message, only: [:show, :update, :destroy]

    def new
      @message = discuss_current_user.messages.new
    end

    def show
      redirect_to edit_message_path(message) unless message.received? || message.sent?
    end

    def create
      @message = Message.new(message_params.merge(user: discuss_current_user))
      if @message.save
        send_message
      else
        render :new
      end
    end

    # [e] avoiding validation exception. Should be done nicer
    def reply
      @message = Message.find(params[:message_id])
      if params[:message][:body]
        @message.reply! message_params.merge(user: discuss_current_user)
        redirect_to mailbox_path(:inbox), notice: 'Reply sent'
      else
        redirect_to message, alert: "Don't you want to say something?"
      end
    end

    def edit
      redirect_to message unless message.unsent?
    end

    def update
      message.update(message_params)
      send_message
    end

    def trash
      @message = Message.find(params[:message_id])
      @message.trash!
      redirect_to mailbox_path(:inbox), notice: 'Message moved to trash'
    end

    def destroy
      message.delete!
      redirect_to mailbox_path(:inbox), notice: 'Message deleted'
    end

    private
    def message
      @message ||= Message.find(params[:id])
    end
    helper_method :message

    def message_params
      params.require(:message).permit(:subject, :body, :draft, draft_recipient_ids: [])
    end

    def send_message
      message.send!
      notice = message.sent? ? 'Yay! Message sent' : 'Draft saved'
      redirect_to mailbox_path(:inbox), notice: notice
    end
  end
end
