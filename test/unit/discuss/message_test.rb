require 'test_helper'

module Discuss
  class MessageTest < MiniTest::Spec
    it 'must be valid' do
      message = Message.new()
      refute message.valid?
      assert_equal 2, message.errors.count
    end

    it 'is read! once' do
      message = @sender.messages.create(body: 'lorem', draft_recipients: [@recipient])
      message.send!
      received = Mailbox.new(@recipient).inbox.first
      received.read!
      assert received.read?

      timestamp = received.read_at
      received.read! # again
      assert_equal timestamp, received.read_at, 'read_at timestamp should not change'
    end


    context "draft" do
      it 'returns proper user depending if there are recipients' do
        m = Message.new(body: 'abc', user: User.first)
        assert_equal m.unsent?, true
        assert_equal m.sender, User.first

        m.update(draft_recipients: User.find([2,3]))
        assert_equal m.sender, User.first
      end
    end

    context 'with users' do
      it 'should have a user' do
        message = @sender.messages.new
        refute_nil message.user
      end

      context 'when sent' do
        before do
          @message = @sender.messages.create(body: 'lorem', draft_recipients: [@recipient])
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
          before { @received_by_recipient = Mailbox.new(@recipient).inbox.first }

          it 'cannot be edited' do
            assert_raises(ActiveRecord::RecordInvalid) { @received_by_recipient.update!(subject: 'new subject') }
          end

          context 'conversation' do
            before do
              @received_by_recipient.reply!(body: 'awesome')
              @reply_received_by_sender = Mailbox.new(@sender).inbox.first
              @reply_received_by_sender.reply!(body: 'duly noted!')
            end

            it 'has correct recipients size' do
              assert_equal 5, @message.descendants.count
              assert_equal 1, @message.recipients.count
            end
          end
        end
      end

    end

    context 'message held by multiple threads' do
      require 'thread'

      it 'can only be sent once' do
        @message = @sender.messages.create(body: 'lorem', draft_recipients: [@recipient])

        t1 = Thread.new { @message.send! }
        t2 = Thread.new { @message.send! }

        t1.join
        t2.join

        assert_equal 1, @message.children.count
      end

    end
  end
end
