require 'test_helper'

module Discuss
  class ConversationTest < MiniTest::Spec
    before do
      @message = @sender.messages.create(body: 'lorem ipsum', recipients: [@recipient])
      @message.send!
      @received = Message.last
      @received.reply! body: 'awesome'
    end

    # [e] just sanity checking before any other tests
    it 'has total of 4 messages' do
      assert_equal 4, Message.count
    end

    context 'sender?' do
      before { @conversation = Conversation.new(@message) }

      it 'has a root' do
        assert_equal @message, @conversation.root
      end

      it 'can find all conversation-related messages' do
        assert_equal 4, @conversation.all.count
      end

      it 'find messages the user owns' do
        assert_equal 2, @conversation.for_user.count
      end

      it 'places messages in the correct mailbox' do
        @mb = Mailbox.new(@sender)
        assert_includes @mb.inbox, Message.last
        assert_includes @mb.outbox, @message
      end

      context 'when not message owner' do
        it 'still find the correct messages' do
          @recipient_conversation = Conversation.new(@message, @recipient)
          refute_equal @recipient_conversation.for_user, @conversation.for_user
        end
      end
    end

    context 'recipient?' do
      before { @conversation = Conversation.new(@received) }

      it 'has a root' do
        assert_equal @message, @conversation.root
      end

      it 'can find all conversation-related messages' do
        assert_equal 4, @conversation.all.count
      end

      it 'find messages the user owns' do
        assert_equal 2, @conversation.for_user.count
      end

      it 'places messages in the correct mailbox' do
        @mb = Mailbox.new(@recipient)
        assert_includes @mb.inbox, @received
        refute_includes @mb.outbox, Message.last
      end
    end
  end
end
