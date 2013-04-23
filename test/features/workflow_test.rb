require 'test_helper'

class WorkFlowTest < FeatureTest

  before(:each) do
  end

  it "seeing an empty inbox" do
    visit "/discuss/messages/inbox" # discuss.mailbox_path(:inbox)
  end

end
