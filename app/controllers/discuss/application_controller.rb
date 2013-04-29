module Discuss
  class ApplicationController < ::ApplicationController
    before_action :current_user

    private
    def current_user
      @current_user ||= User.where(email: 'user@test.com', first_name: 'hell', last_name: 'boy').first_or_create
    end
    helper_method :current_user
  end
end
