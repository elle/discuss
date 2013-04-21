module Discuss
  class Recipient < ActiveRecord::Base
    self.table_name = "recipients"

    belongs_to :message, class_name: "Discuss::Message"
    belongs_to :discuss_user, class_name: "Discuss::DiscussUser"
  end
end
