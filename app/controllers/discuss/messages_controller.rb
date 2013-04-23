require_dependency 'discuss/application_controller'

module Discuss
  class MessagesController < ApplicationController
    before_action :check_mailbox_params, only: :index
    before_action :message, only: [:show, :update, :destroy]

    def index
      @messages = Message.send(params[:mailbox], user)
    end

    def create
      @message = user.sent_messages.new(message_params)
      if @message.save
        redirect_to mailbox_path(:inbox), notice: 'Yay! Message sent'
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
    def user
      @user ||= DiscussUser.find_by(user_id: current_discuss_user.id, user_type: current_discuss_user.class.to_s)
    end
    helper_method :user

    def message
      @message ||= Message.find(params[:id])
    end
    helper_method :message

    def check_mailbox_params
      redirect_to mailbox_path(:inbox) unless valid_mailbox?
    end

    def valid_mailbox?
      %w{inbox sent drafts trash}.include? params[:mailbox]
    end

    def mailbox_name
      params[:mailbox]
    end
    helper_method :mailbox_name

    def message_params
      params.require(:message).permit(:subject, :body, :parent_id, :recipients)
    end
  end
end
