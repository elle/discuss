require 'test_helper'

module Discuss
  class MailboxTest < MiniTest::Spec
    before do
      @sender = DiscussUser.create(email: 'fred@flintstones.com', name: 'fred', user_id: 1)
      @recipient = DiscussUser.create(email: 'barney@rubble.com', name: 'barney', user_id: 2)
      @message = @sender.messages.new(body: 'lorem ipsum', recipients: [@recipient])
      @message.send!
    end

    context 'sender?' do
      it 'has inbox'
      it 'has sent box'
      it 'has drafts box'
      it 'has trash box'
      it 'can empty_trash'
    end

    context 'recipient?' do
      it 'has inbox'
      it 'has sent box'
      it 'has drafts box'
      it 'has trash box'
      it 'can empty_trash'
    end

    context 'conversation' do
    end
  end
end
