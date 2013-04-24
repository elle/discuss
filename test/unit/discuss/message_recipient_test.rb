require 'test_helper'

module Discuss
  class MessageRecipientTest < MiniTest::Spec
    before(:each) do
      @teacher  = DiscussUser.create!(email: 'admin@admin.com', user_type: 'teacher', user_id: 4)
      @student = DiscussUser.create!(email: 'student@student.com', user_type: 'student', user_id: 1)
    end

    context 'with message' do
      context 'when received message is trashed' do
        before do
          @teacher.sent_messages.create!(body: 'abc', recipients: [@student])
          @received = MessageRecipient.last
          @message = @received.message
          @received.trash!
        end

        it 'should not be included in #inbox scope' do
          assert @received.trashed?
          assert_includes Message.trashed_received(@student), @message
          assert_includes Message.trash(@student), @message
        end
      end
    end
  end
end
