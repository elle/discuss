module Discuss
  class ApplicationController < ActionController::Base
    before_action :current_user


    private
    def current_discuss_user
      current_user
    end
  end
end
