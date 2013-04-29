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
        refute_nil message.user
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

        context 'when received' do
          before { @received = Mailbox.new(@recipient).inbox.first }

          it 'cannot be edited' do
            assert_raises(ActiveRecord::RecordInvalid) { @received.update!(subject: 'new subject') }
          end

          context 'when replied' do
            before { @received.reply!(body: 'awesome') }
          end
        end
      end

    end

    context 'message held by multiple threads' do
      require 'thread'

      it 'can only be sent once' do
        @message = @sender.messages.create(body: 'lorem', recipients: [@recipient])

        t1 = Thread.new { @message.send! }
        t2 = Thread.new { @message.send! }

        t1.join
        t2.join

        assert_equal 1, @message.children.count
      end

    end
  end
end
