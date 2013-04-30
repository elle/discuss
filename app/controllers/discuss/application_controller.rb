module Discuss
  class ApplicationController < ::ApplicationController
    before_action :discuss_current_user

    private
    def discuss_current_user
      raise 'Must override me' unless current_user
    end
    helper_method :discuss_current_user
  end
end
