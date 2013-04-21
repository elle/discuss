module Discuss
  class DiscussUser < ActiveRecord::Base
    self.table_name = "discuss_users"

    has_many :recipients, class_name: "Discuss::Recipient"
    has_many :messages, class_name: "Discuss::Message", through: :recipients
  end
end
