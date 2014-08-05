require_dependency 'discuss/application_controller'

module Discuss
  class MessagesController < ApplicationController
    before_action :message, only: [:show, :update, :destroy]
    before_action :can_view_message, only: [:show, :edit, :destroy]

    def new
      @message = discuss_current_user.messages.new
    end

    def show
      message.read! if message.received? || message.unread?
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
        set_flash_message :notice, :replied
        redirect_to mailbox_path(:inbox)
      else
        set_flash_message :alert, :invalid
        redirect_to message
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
      set_flash_message :notice, :trashed
      redirect_to mailbox_path(:inbox)
    end

    def destroy
      message.delete!
      set_flash_message :notice, :deleted
      redirect_to mailbox_path(:inbox)
    end

    private
    def message
      @message ||= Message.find(params[:id])
    end
    helper_method :message

    def message_params
      p = params.require(:message).permit(:subject, :body, :draft, draft_recipients: [])
      p[:draft_recipients].reject!(&:blank?).map! { |json| recipient_from_json(json) } if p[:draft_recipients].present?
      p
    end

    def send_message
      message.send!
      notice = message.sent? ? set_flash_message(:notice, :sent) : set_flash_message(:notice, :saved)
      redirect_to mailbox_path(:inbox), notice: notice
    end

    def mailbox_name
      params[:mailbox] || message.mailbox.to_s
    end
    helper_method :mailbox_name

    def can_view_message
      unless mine?
        set_flash_message :notice, :unauthorised
        redirect_to mailbox_path(:inbox)
      end
    end

    def mine?
      message.user == discuss_current_user
    end
  end
end
