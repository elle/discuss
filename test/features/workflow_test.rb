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
  before(:each) do
    @disscuss_user = Discuss::DiscussUser.create(user_id: 1, email: "test@test.com", name: "tester")
  end

  it "seeing an empty inbox" do
    visit "/discuss/messages/inbox" # discuss.mailbox_path(:inbox)
  end
end

