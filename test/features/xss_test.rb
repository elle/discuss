require 'test_helper'

class XssTest< FeatureTest
  let(:body) { 'lorem ipsum' }

  before do
    @message = @sender.messages.create(body: body, draft_recipients: [@recipient])
    @message.send!
    @message2 = @recipient.messages.create(body: body, draft_recipients: [@sender])
    @message2.send!
  end

  context 'with malicious iframe in body' do
    let(:body) { "<iframe/oNloAd=alert('XSS')//>\x3e" }

    it "message page doesn't do bad things" do
      visit "/discuss/message/#{@message.id}"

      within '.body' do
        # save_and_open_page # demonstrate XSS manually, not going to install PhantomJS just for this
        refute page.has_css?('iframe')
      end
    end

    it "mailbox page doesn't do bad things" do
      visit "/discuss/mailbox/inbox"

      within '.preview' do
        refute page.has_css?('iframe')
      end
    end
  end

  context 'with malicious iframe in body' do
    let(:body) { "<iframe/oNloAd=alert('XSS')//>\x3e" }

    # never a vulnerability here, without markdown processing it was always blocked by Rails
    it "message page doesn't do bad things" do
      visit "/discuss/message/#{@message.id}"

      within '.body' do
        refute page.has_css?('iframe')
      end
    end
  end
end
