require 'test_helper'

module Discuss
  class RecipientTest < MiniTest::Spec
    before do
      @message = @sender.messages.create(body: 'lorem ipsum', draft_recipients: [@recipient])
      @message.send!
      @received = Mailbox.new(@recipient).inbox.first
    end

    it 'cannot reply if no parent' do
      assert_equal 2, Message.count
      refute @message.parent
      @message.reply! body: 'awesome'
      assert_equal 2, Message.count
    end

    it 'does not deliver if no :body' do
      assert_raises(ActiveRecord::RecordInvalid) { @received.reply! }
    end

    it 'has a parent message' do
      assert_equal @message, @received.parent
    end

    context 'when replying' do
      before do
        @text = 'awesome'
        @received.reply! body: @text
      end

      it 'reply to sender' do
        assert_equal 4, Message.count
      end

      it 'is delivered to @sender' do
        @inbox = Mailbox.new(@sender).inbox
        assert_equal 1, @inbox.count
        assert_equal @text, @inbox.last.body
      end

      it "has the reply in the @recipient's outbox" do
        @outbox = Mailbox.new(@recipient).outbox
        assert_equal 1, @outbox.count
        assert_equal @text, @outbox.last.body
      end

      it 'has ancestry tree' do
        last_message = Message.last
        assert_equal 3, last_message.ancestors.count
        assert_equal @message, last_message.root
      end
    end
  end
end
