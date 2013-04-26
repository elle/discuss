require 'test_helper'

module Discuss
  class MessageTest < MiniTest::Spec
    it 'must be valid' do
      message = Message.new()
      refute message.valid?
      assert_equal 2, message.errors.count
    end

    context 'with users' do
      it 'should have a user' do
        message = @sender.messages.new
        refute_nil message.discuss_user
      end

      context 'when sent' do
        before do
          @message = @sender.messages.create(body: 'lorem', recipients: [@recipient])
          @message.send!
          refute @message.editable?
        end

        it 'cannot be edited once sent' do
          assert_raises(ActiveRecord::RecordInvalid) { @message.update!(body: 'abc') }
        end

        it 'cannot go back to being a draft once sent' do
          assert_raises(ActiveRecord::RecordInvalid) { @message.update!(sent_at: nil) }
        end

        it 'cannot be edited if recieved' do
          received = Mailbox.new(@recipient).inbox.first
          assert_raises(ActiveRecord::RecordInvalid) { received.update!(subject: 'new subject') }
        end
      end
    end
  end
end
