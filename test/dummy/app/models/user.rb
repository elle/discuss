class User < ActiveRecord::Base

  acts_as_discussable

  validates :email, presence: true

  def to_s
    prefix
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def prefix
    "#{full_name} #{email}"
  end
end
