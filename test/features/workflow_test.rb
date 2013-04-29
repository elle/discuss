require 'test_helper'

class WorkFlowTest < FeatureTest
  before { @u = User.create(email: "test@test.com", first_name: "tester") }

  it 'seeing an empty inbox' do
    visit "/discuss/mailbox/inbox" # discuss.mailbox_path(:inbox)
    assert page.has_content?('Inbox')
    assert page.has_content?('0 messages')
  end
end

