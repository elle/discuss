require 'test_helper'

module Discuss
  describe 'sender' do
    before do
      @teacher = DiscussUser.create!(email: 'admin@admin.com', user_type: 'teacher', user_id: 4)
      @bart = DiscussUser.create!(email: 'bart@student.com', user_type: 'student', user_id: 1)
      @lisa = DiscussUser.create!(email: 'lisa@student.com', user_type: 'student', user_id: 2)
    end

    context 'when draft' do
      it 'saved message as draft when no recipients' do
        message = @teacher.messages.create(body: 'lorem ipsum')
        assert message.draft?
      end

      context 'with recipients' do
        before { @message = @teacher.messages.create(body: 'lorem ipsum', recipients: [@bart, @lisa]) }

        it 'defaults to draft' do
          assert @message.draft?
        end

        it 'should not deliver the message' do
          assert_equal 1, Message.count
        end

        it 'when trashed, should not be included in the drafts scope' do
          @message.trash!
          assert_includes Message.trash(@teacher), @message
          refute_includes Message.drafts(@teacher), @message
        end
      end
    end

    context 'when sending' do
      it 'sends a message by calling #send!'
      it 'can have multiple recipients'
      it 'sets sent_at but not received_at'
      it 'is included in the #sent scope'
      it 'when trashed, should not be included in the drafts scope'
    end

    context 'when trashed' do
      it 'is included in the #trash scope'
      it 'is not included in the #deleted scope'
      it 'still appears in the recipient inbox'
    end

    context 'when deleted' do
      it 'can be deleted'
      it 'does not appear in the #trash scope'
    end

  end
end


