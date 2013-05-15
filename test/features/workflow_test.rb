require 'test_helper'

class WorkFlowTest< FeatureTest

  it 'seeing an empty inbox' do
    visit "/discuss/mailbox/inbox" # discuss.mailbox_path(:inbox)
    assert page.has_content?('Inbox')
    assert page.has_content?('0 messages')
  end

  context 'new message' do
    it 'composes a draft' do
      visit '/discuss/message/compose'
      select 'bart simpsons', from: 'Recipients'
      fill_in 'Subject', with: 'camping trip'
      fill_in 'Your message', with: "who's bringing what?"
      check 'Draft'
      click_on 'Send message'

      assert page.has_css?('div.notice')
      assert_equal 1, Discuss::Mailbox.new(@sender).drafts.count
      assert_equal 0, Discuss::Mailbox.new(@recipient).inbox.count
    end

    it 'sends a message' do
      visit '/discuss/message/compose'
      select 'bart simpsons', from: 'Recipients'
      fill_in 'Subject', with: 'camping trip'
      fill_in 'Your message', with: "who's bringing what?"
      click_on 'Send message'
      assert page.has_css?('div.notice')
      assert_equal 1, Discuss::Mailbox.new(@sender).outbox.count
      assert_equal 1, Discuss::Mailbox.new(@recipient).inbox.count
    end
  end

  context 'with messages' do
    before do
      @draft = @sender.messages.create(body: 'only for me eyes', recipients: [@lisa])
      @message = @sender.messages.create(body: 'lorem ipsum', recipients: [@recipient])
      @message.send!
      @outbox = Discuss::Mailbox.new(@sender).outbox
    end

    it 'sees an outbox' do
      assert_equal 1, @outbox.count

      visit '/discuss/mailbox/outbox'
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

    it 'moves a message to trash' do
      visit "/discuss/message/#{@message.id}"
      click_on 'Move to trash'
      assert page.has_content?('Message moved to trash')
      assert_equal 0, Discuss::Mailbox.new(@sender).outbox.count
      assert_equal 1, Discuss::Mailbox.new(@sender).trash.count
    end

    it 'empties trash' do
      @message.trash!
      assert_equal 1, Discuss::Mailbox.new(@sender).trash.count

      visit '/discuss/mailbox/trash'
      click_on 'Empty trash'
      assert page.has_content?('Trash has been emptied')
      assert_equal 0, Discuss::Mailbox.new(@sender).trash.count
    end

    it 'views a sent message' do
      visit "/discuss/message/#{@message.id}"

      within '.headers' do
        assert page.has_content?(@message.sender)
        assert page.has_content?('Recipients: bart simpsons')
      end
    end

    it 'views a recieved message' do
      message = Discuss::Mailbox.new(@recipient).inbox.first
      message.reply! body: 'first reply'
      recieved_message = Discuss::Mailbox.new(@sender).inbox.last

      visit "/discuss/message/#{recieved_message.id}"
      within 'div.compose' do
        assert page.has_xpath?("//form[@action='/discuss/message/#{recieved_message.id}/reply']")
        refute page.has_content?('Recipients')
      end
    end

    it 'redirects to show view if uneditable?' do
      visit "/discuss/message/#{@message.id}/edit"
      assert_equal "/discuss/message/#{@message.id}", current_path
    end

    it 'redirects to edit view if unsent?' do
      visit "/discuss/message/#{@draft.id}"
      assert_equal "/discuss/message/#{@draft.id}/edit", current_path
    end

    it 'sends a draft' do
      visit "/discuss/message/#{@draft.id}/edit"
      fill_in 'Subject', with: 'great to go public'
      fill_in 'Your message', with: 'not for my eyes only anymore'
      click_on 'Send message'

      assert page.has_css?('div.notice')
      assert_equal 0, Discuss::Mailbox.new(@sender).drafts.count
      assert_equal 1, Discuss::Mailbox.new(@lisa).inbox.count
    end

    it 'edits a draft' do
      visit "/discuss/message/#{@draft.id}/edit"
      fill_in 'Subject', with: 'not yet'
      check 'Draft'
      click_on 'Send message'

      assert page.has_css?('div.notice')
      assert_equal 1, Discuss::Mailbox.new(@sender).drafts.count
      assert_equal 0, Discuss::Mailbox.new(@lisa).inbox.count
    end

    it 'does not see reply form if I sent the message' do
      assert_equal @sender, @message.sender
      visit "/discuss/message/#{@message.id}"
      refute page.has_css?('.compose.reply')
    end

    it 'replies' do
      message = Discuss::Mailbox.new(@recipient).inbox.first
      message.reply! body: 'first reply'
      recieved_message = Discuss::Mailbox.new(@sender).inbox.last

      visit "/discuss/message/#{recieved_message.id}"

      within 'div.compose' do
        fill_in 'Your message', with: 'This is what I think on your previous message'
        click_on 'Reply'
      end

      assert page.has_css?('div.notice')
      assert_equal 2, Discuss::Mailbox.new(@sender).outbox.count
      assert_equal 2, Discuss::Mailbox.new(@recipient).inbox.count
    end
  end
end

