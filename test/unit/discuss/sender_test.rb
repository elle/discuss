require 'test_helper'

module Discuss
  describe 'sender' do
    context 'when draft' do
      context 'without recipients' do
        before do
            @message = @sender.messages.create(body: 'lorem ipsum')
        end

        it 'saved message as draft when no recipients' do
          assert @message.draft?
        end

        it 'does not deliver' do
          @message.send!
          assert @message.unsent?
          assert @message.is_childless?
        end
      end

      context 'with recipients' do
        before { @message = @sender.messages.create(body: 'lorem ipsum', recipients: [@recipient, @lisa]) }

        it 'defaults to draft' do
          assert @message.draft?
        end

        it 'should not deliver the message' do
          assert_equal 1, Message.count
        end

        it 'when trashed, should not be included in the #drafts scope' do
          @message.trash!
          assert_includes Message.trash(@sender), @message
          refute_includes Message.drafts(@sender), @message
        end
      end
    end

    context 'when sending' do
      before do
        @message = @sender.messages.create(body: 'lorem ipsum', recipients: [@recipient, @lisa])
        @message.send!
      end

      it 'sends a message by calling #send!' do
        assert @message.sent?
      end

      it 'can have multiple recipients' do
        assert_equal 2, @message.children.count
      end

      it 'sets sent_at but not received_at' do
        assert @message.sent?
        refute @message.received?
      end

      it 'is included in the #sent scope' do
        assert_includes Message.outbox(@sender), @message
      end

      it 'when trashed, should not be included in the #outbox scope' do
        @message.trash!
        assert_includes Message.trash(@sender), @message
        refute_includes Message.outbox(@sender), @message
      end
    end

    context 'when trashed' do
      it 'still appears in the recipient inbox' do
        message = @sender.messages.create(body: 'lorem ipsum', recipients: [@recipient, @lisa])
        message.send!
        message.trash!
      end
    end

    context 'when deleted' do
      before do
        @message = @sender.messages.create(body: 'lorem ipsum', recipients: [@recipient, @lisa])
        @message.send!

        assert_equal 1, Message.inbox(@recipient).count
        @received_message = Message.inbox(@recipient).last

        @message.delete!
      end

      it 'can be deleted' do
        assert @message.deleted?
      end

      it 'is not included in the #trash scope' do
        refute_includes Message.trash(@sender), @message
      end

      it 'still appears in the recipient inbox' do
        assert_includes Message.inbox(@recipient), @received_message
      end
    end

  end
end


