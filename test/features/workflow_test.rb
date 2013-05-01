require 'test_helper'

class WorkFlowTest< FeatureTest

  it 'seeing an empty inbox' do
    visit "/discuss/mailbox/inbox" # discuss.mailbox_path(:inbox)
    assert page.has_content?('Inbox')
    assert page.has_content?('0 messages')
  end

  context 'with messages' do
    before do
      @draft = @sender.messages.create(body: 'only for me eyes', recipients: [@lisa])
      @message = @sender.messages.create(body: 'lorem ipsum', recipients: [@recipient])
      @message.send!
      @outbox = Discuss::Mailbox.new(@sender).outbox
      assert_equal 1, @outbox.count
    end

    it 'sees an outbox' do
      visit '/discuss/mailbox/outbox'
      #print page.html
      assert page.has_content?('1 message')
      within '.messages' do
        assert page.has_content?(@recipient.to_s)
      end
    end

    it 'sees drafts' do
      visit '/discuss/mailbox/drafts'
      assert page.has_content?('Drafts')

      within '.messages' do
        assert page.has_content?(@draft.body)
        assert page.has_content?(@lisa.to_s)
      end
    end

    it 'sees trash' do
      @draft.trash!
      @outbox.first.trash!
      visit '/discuss/mailbox/trash'
      assert page.has_content?('Trash')
      assert page.has_content?('2 messages')

      within '.messages' do
        assert_equal 2, page.all('.discuss_message').size
        assert page.has_content?(@draft.body)
        assert page.has_content?(@recipient.to_s)
      end
    end
  end
end

