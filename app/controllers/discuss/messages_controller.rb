require_dependency 'discuss/application_controller'

module Discuss
  class MessagesController < ApplicationController
    before_action :message, only: [:show, :update, :destroy]

    def new
      @message = discuss_current_user.messages.new
    end

    def show
      redirect_to edit_message_path(message) if message.unsent?
    end

    def create
      @message = Message.create(message_params.merge(user: discuss_current_user))
      send_message
    end

    def edit
      redirect_to message unless message.unsent?
    end

    def update
      message.update(message_params)
      send_message
    end

    def destroy
      message.delete! # [e] This is not accurate, it needs to handle if message is sent or received here
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
      notice = message.sent? ? 'Yay!, Message sent' : 'Draft saved'
      redirect_to mailbox_path(:inbox), notice: notice
    end
  end
end
