require_dependency 'discuss/application_controller'

module Discuss
  class MailboxesController < ApplicationController
    before_action :check_mailbox_params, only: :show

    def show
      @messages = Mailbox.new(discuss_current_user).send mailbox_name
    end

    private
    def check_mailbox_params
      redirect_to mailbox_path(:inbox) unless valid_mailbox?
    end

    def valid_mailbox?
      %w{inbox outbox drafts trash}.include? params[:mailbox]
    end

    def mailbox_name
      params[:mailbox]
    end
    helper_method :mailbox_name
  end
end
