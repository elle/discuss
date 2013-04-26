require 'test_helper'

module Discuss
  class RecipientTest < MiniTest::Spec
    before do
      @teacher  = DiscussUser.create!(email: 'admin@admin.com', user_type: 'teacher', user_id: 4)
      @student = DiscussUser.create!(email: 'student@student.com', user_type: 'student', user_id: 1)
    end

  end
end
