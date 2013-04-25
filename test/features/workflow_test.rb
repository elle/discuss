require 'test_helper'

class User
  attr_reader :id
  def initialize(id)
    @id = id
  end
end

def current_user
  User.new(1)
end

class WorkFlowTest < FeatureTest
  before { @u = Discuss::DiscussUser.create(user_id: 1, email: "test@test.com", name: "tester") }

  it 'seeing an empty inbox' do
    visit "/discuss/mailbox/inbox" # discuss.mailbox_path(:inbox)
    assert page.has_content?('Inbox')
    assert page.has_content?('0 messages')
  end
end

