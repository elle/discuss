class User < ActiveRecord::Base

  has_many :messages, class_name: 'Discuss::Message'

  validates :email, presence: true

  def to_s
    prefix
  end

  def full_name
    "#{try(:first_name)} #{try(:last_name)}"
  end

  def prefix
    "#{full_name} #{email}"
  end
end
