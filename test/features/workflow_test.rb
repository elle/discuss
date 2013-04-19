require 'test_helper'

module Discuss
  class WorkflowTest < MiniTest::Spec

    describe "something" do

      it "sends a message by calling ::create" do
        message = Message.create(
          :discuss_user_id => 1,
          :subject => "blah",
          :body => "abc",
          :recipient_emails => ["user2@gmail.com"]
        )

        assert message.valid?
      end

    end

  end
end
