module Discuss
  class Message < ActiveRecord::Base
    self.table_name = "messages"

    def recipient_emails=(str)
    end

    def recipient_emails
    end
  end
end
