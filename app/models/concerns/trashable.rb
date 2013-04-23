module Trashable
  extend ActiveSupport::Concern

  included do
    scope :trashed,     -> { where('trashed_at is not NULL') }
    scope :not_trashed, -> { where('trashed_at is NULL') }

    scope :deleted,     -> { where('deleted_at is not NULL') }
    scope :not_deleted, -> { where('deleted_at is NULL') }

    scope :active,  -> { not_draft.not_trashed.not_deleted }
  end

  def trash!
    update(trashed_at: Time.now)
  end

  def delete!
    update(deleted_at: Time.now)
  end

  def active?
    Message.active.include?(self)
  end

  def trashed?
    trashed_at.present?
  end

  def deleted?
    deleted_at.present?
  end

end
