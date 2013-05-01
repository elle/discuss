class User < ActiveRecord::Base

  has_many :messages, class_name: 'Discuss::Message'

  validates :email, presence: true

  def to_s
    full_name
  end

  def full_name
    "#{try(:first_name)} #{try(:last_name)}"
  end

  def prefix
    try(:full_name) || email
  end

  def message_title
    "#{prefix} <#{email}>"
  end
end
