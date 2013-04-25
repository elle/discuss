require 'test_helper'

module Discuss
  class MailboxTest < MiniTest::Spec
    before do
      @sender = DiscussUser.create(email: 'fred@flintstones.com', name: 'fred', user_id: 1)
      @recipient = DiscussUser.create(email: 'barney@rubble.com', name: 'barney', user_id: 1)
      @message = @sender.messages.new(body: 'lorem ipsum', recipients: [@recipient])
      @message.send!
    end

    context 'sender?' do
      before { @mailbox = Mailbox.new(@message, @sender) }

      it 'recognises sender?' do
        assert @mailbox.sender?
      end

      it '#trash!' do
        @mailbox.trash!
        assert @message.trashed?
        assert_includes Message.trash(@sender), @message
      end

      it '#delete!' do
        @mailbox.trash!
        @mailbox.delete!
        assert @message.deleted?
      end

      it 'deletes a draft'
    end

    context 'recipient?' do
      before { @mailbox = Mailbox.new(@message, @recipient) }

      it 'recognises recipient?' do
        assert @mailbox.recipient?
      end

      it '#trash!' do
        @mailbox.trash!
        assert_includes Message.trash(@recipient), @message
      end

      it '#delete!' do
        @mailbox.trash!
        @mailbox.delete!
        assert @message.deleted?
        refute_includes Message.trash(@recipient), @message
      end

      it 'deletes a draft'

      it '#read!' do
        @mailbox.read!
        assert_includes Message.read(@recipient), @message
      end
    end

    context 'when there is trash' do
      it '#empty_trash!'
    end

    context 'conversation' do
    end
  end
end
