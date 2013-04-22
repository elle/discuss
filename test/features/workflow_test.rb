require 'test_helper'

module Discuss
  class WorkflowTest < MiniTest::Spec

    it 'must be valid' do
      message = Message.new()
      refute message.valid?
      assert_equal 2, message.errors.count
    end

    context 'Creating a message' do
      before(:each) do
        @teacher  = DiscussUser.create!(email: 'admin@admin.com', user_type: 'teacher', user_id: 4)
        @student1 = DiscussUser.create!(email: 'student@student.com', user_type: 'student', user_id: 1)
        @student2 = DiscussUser.create!(email: 'ss@ss.com', user_type: 'student', user_id: 2)
      end

      it 'sends a message by calling ::create' do
        message = @teacher.sent_messages.create!(body: 'abc', recipients: [@student1])

        assert message.valid?
        assert_equal 1, @teacher.sent_messages.count
        assert_equal 1, Message.sent(@teacher).count
      end

      it 'allows multipule recipients' do
        message = @teacher.sent_messages.create!(body: 'abc', recipients: [@student1, @student2])

        assert_equal 1, Message.count
        assert_equal 2, message.recipients.count
        assert_equal 1, @student1.received_messages.count
        assert_equal 1, Message.inbox(@student2).count
      end

      context 'when draft' do
        it 'when no recipients saves message as draft' do
          message = @teacher.sent_messages.create!(body: 'lorem ipsum')

          assert message.draft?
          assert_equal 0, MessageUser.count
          assert_equal 0, @teacher.sent_messages.count
          assert_equal 1, Message.drafts(@teacher).count
        end

        it 'should not deliver the message' do
          message = @teacher.sent_messages.create!(body: 'lorem ipsum', recipients: [@student1], draft: true)

          assert message.draft?
          assert_equal 0, @student1.received_messages.count
        end
      end
    end

  end
end
