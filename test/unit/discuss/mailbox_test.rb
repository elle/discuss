require 'test_helper'

module Discuss
  class MailboxTest < MiniTest::Spec
    before do
      @sender = DiscussUser.create(email: 'fred@flintstones.com', name: 'fred')
      @recipient = DiscussUser.create(email: 'barney@rubble.com', name: 'barney')
      @draft = @sender.messages.create(body: 'lorem ipsum', recipients: [@recipient])
      @message = @sender.messages.create(body: 'lorem ipsum', recipients: [@recipient])
      @message.send!
    end

    context 'sender?' do
      before { @mailbox = Mailbox.new(@sender) }

      it 'inbox' do
        assert_equal 0, @mailbox.inbox.count
      end

      it 'outbox' do
        assert_equal 1, @mailbox.outbox.count
      end

      it 'drafts' do
        assert_equal 1, @mailbox.drafts.count
      end

      it 'trash' do
        @message.trash!
        assert_equal 0, @mailbox.outbox.count
        assert_equal 1, @mailbox.trash.count
      end

      it 'can empty_trash!' do
        @draft.trash!
        assert_equal 0, @mailbox.drafts.count
        assert_equal 1, @mailbox.trash.count

        @mailbox.empty_trash!
        assert_equal 0, @mailbox.trash.count
      end
    end

    context 'recipient?' do
      before { @mailbox = Mailbox.new(@recipient) }

      it 'inbox' do
        assert_equal 1, @mailbox.inbox.count
      end

      it 'outbox' do
        assert_equal 0, @mailbox.outbox.count
      end

      it 'drafts' do
        assert_equal 0, @mailbox.drafts.count
      end

      it 'trash' do
        message = @mailbox.inbox.first
        message.trash!
        assert_equal 0, @mailbox.inbox.count
        assert_equal 1, @mailbox.trash.count
      end

      it 'can empty_trash' do
        message = @mailbox.inbox.first
        message.trash!
        @mailbox.empty_trash!
        assert_equal 0, @mailbox.trash.count
      end
    end

    context 'conversation' do
    end
  end
end
