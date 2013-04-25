require 'test_helper'

module Discuss
  class MessageTest < MiniTest::Spec
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

      context 'sending a message' do
        before do
          @message = @teacher.messages.new(body: 'abc', recipients: [@student1, @student2])
          @message.send!
        end

        it 'sends a message by calling #send!' do
          assert_equal 1, @teacher.sent_messages.count
          assert_equal 1, Message.sent(@teacher).count
        end

        it 'allows multiple recipients' do
          assert_equal 2, @message.recipients.count
          assert_equal 1, @student1.received_messages.count
          assert_equal 1, Message.inbox(@student2).count
        end

        it 'sets #sent_at' do
          assert @message.sent?
        end

        it 'cannot go back to being a draft once sent' do
          @message.sent_at = Time.now
          @message.save!
          @message.reload
          refute @message.draft?
        end
      end

      context 'when draft' do
        it 'when no recipients saves message as draft' do
          message = @teacher.messages.create!(body: 'lorem ipsum')

          assert message.recipients.empty?
          assert_equal 0, @teacher.sent_messages.count
          assert_equal 1, @teacher.draft_messages.count
          assert_equal 1, Message.drafts(@teacher).count
        end

        it 'should not deliver the message' do
          message = @teacher.messages.create!(body: 'lorem ipsum', recipients: [@student1])

          assert message.draft?
          assert message.unsent?
          assert_equal 0, @student1.received_messages.count
        end

        it 'when trashed, should not longer be included in #draft scope' do
          message = @teacher.messages.create!(body: 'lorem ipsum', recipients: [@student1])
          message.trash!

          assert message.trashed?
          assert_equal 0, Message.drafts(@teacher).count
        end
      end

      context 'when trashed sent message' do
        before(:each) do
          @message = @teacher.messages.new(body: 'abc', recipients: [@student1])
          @message.send!
          @message.trash!
        end

        it 'should be included in #trash scope' do
          assert_equal 1, Message.trash(@teacher).count
        end

        it 'should not be inlucded in #sent scope' do
          assert_equal 0, Message.sent(@teacher).count
        end

        it 'should still appear on the recipient side' do
          assert_equal 1, Message.inbox(@student1).count
        end
      end
    end
  end
end
