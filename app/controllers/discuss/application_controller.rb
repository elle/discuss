module Discuss
  class ApplicationController < ::ApplicationController
    before_action :user

    private
    def current_discuss_user
      current_user
    end

    def user
      @user ||= DiscussUser.find_by(user_id: current_discuss_user.id, user_type: current_discuss_user.class.to_s)
    end
    helper_method :user
  end
end
