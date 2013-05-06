require_dependency 'discuss/application_controller'

module Discuss
  class MessagesController < ApplicationController
    before_action :message, only: [:show, :update, :destroy]

    def new
      @message = discuss_current_user.messages.new
    end

    def show
    end

    def create
      @message = discuss_current_user.messages.new(message_params)
      if @message.send!
        redirect_to mailbox_path(:inbox), notice: 'Yay! Message sent'
      else
        render :new
      end
    end

    def save_draft
      @message = user.messages.new(message_params)
      if @message.save
        redirect_to mailbox_path(:inbox), notice: 'Message saved as draft'
      else
        render :new
      end
    end

    def update
      message.update(message_params)
      redirect_to mailbox_path(:inbox)
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
      params.require(:message).permit(:subject, :body, :parent_id, recipient_ids: [])
    end
  end
end
