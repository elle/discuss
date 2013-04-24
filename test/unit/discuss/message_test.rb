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

      it 'sends a message by calling ::create' do
        message = @teacher.sent_messages.create!(body: 'abc', recipients: [@student1])

        assert message.valid?
        assert_equal 1, @teacher.sent_messages.count
        assert_equal 1, Message.sent(@teacher).count
      end

      it 'allows multiple recipients' do
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
          assert_equal 0, MessageRecipient.count
          assert_equal 0, @teacher.sent_messages.count
          assert_equal 1, Message.drafts(@teacher).count
        end

        it 'should not deliver the message' do
          message = @teacher.sent_messages.create!(body: 'lorem ipsum', recipients: [@student1], draft: true)

          assert message.draft?
          assert_equal 0, @student1.received_messages.count
        end
      end

      context 'when trashed sent message' do
        before(:each) { @message = @teacher.sent_messages.create!(body: 'abc', recipients: [@student1], trashed_at: Time.now) }

        it 'should be included in #trash scope' do
          assert_equal 1, Message.trash(@teacher).count
        end

        it 'should not be inlucded in #sent scope' do
          assert_equal 0, Message.sent(@teacher).count
        end

        it 'should not be included in #draft scope' do
          @message.update(draft: true)
          assert @message.draft?
          assert @message.trashed?
          assert_equal 0, Message.drafts(@teacher).count
        end

        it 'should still appear on the recipient side' do
          assert_equal 1, Message.inbox(@student1).count
        end
      end

      context 'message actions' do
        before { @message = @teacher.sent_messages.create(body: 'lorem ipsum', recipients: [@student1]) }

        it '#draft!' do
          refute @message.draft?
          @message.draft!
          assert @message.draft?
        end

        it '#trash!'

        it '#delete!'
        it '#read!'
        it '#emoty_trash!'
      end

      context 'conversation' do
      end
    end
  end
end
