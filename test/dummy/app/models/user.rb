class User < ActiveRecord::Base

  acts_as_discussable

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
