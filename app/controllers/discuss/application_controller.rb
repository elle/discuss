module Discuss
  class ApplicationController < ActionController::Base

    private
    def current_discuss_user
      current_user
    end
  end
end
