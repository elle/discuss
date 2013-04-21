module Discuss
  class Message < ActiveRecord::Base
    self.table_name = "messages"

    has_many :recipients, class_name: "Discuss::Recipient"
    has_many :discuss_users, class_name: "Discuss::DiscussUser", through: :recipients

    validates :body, presence: true
  end
end
