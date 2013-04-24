module Discuss
  class ApplicationController < ::ApplicationController
    before_action :current_discuss_user

    private
    def current_discuss_user
      current_user
    end
  end
end
