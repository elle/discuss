module Discuss
  class DiscussUser < ActiveRecord::Base
    self.table_name = 'discuss_users'

    has_many :messages, foreign_key: :user_id

    validates :email, :user_id, presence: true

    def to_s
      name
    end

    def title
      "#{name} <#{email}>"
    end
  end
end
