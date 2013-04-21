require 'test_helper'

module Discuss
  class WorkflowTest < MiniTest::Spec

    it "must be valid" do
      message = Message.new()
      refute message.valid?
      assert_equal 2, message.errors.count
    end

    describe "Creating a message" do

      before(:each) do
        @du_teacher  = DiscussUser.create!(email: "admin@admin.com", user_type: "teacher", user_id: 4)
        @du_student1 = DiscussUser.create!(email: "student@student.com", user_type: "student", user_id: 1)
        @du_student2 = DiscussUser.create!(email: "ss@ss.com", user_type: "student", user_id: 2)
      end

      it "sends a message by calling ::create" do
        Message.delete_all

        message = Message.create!(
          subject: "abc",
          body: "abc",
          recipients: [@du_student1]
        )

        assert message.valid?
        assert_equal 1, Message.count
      end

      it "allows multipule recipients" do
        Message.delete_all

        message = Message.create!(
          subject: "abc",
          body: "abc",
          recipients: [@du_student1, @du_student2]
        )

        assert_equal 1, Message.count
        assert_equal 2, message.recipients.count
      end

    end

  end
end
