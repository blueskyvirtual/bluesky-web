# frozen_string_literal: true

class Rank < ApplicationRecord
  # Audits
  audited

  # ActiveRecord callbacks
  before_destroy :ensure_no_users

  # ActiveRecord associations
  has_many :users, dependent: :destroy

  # ActiveRecord validations
  validates :name,
            presence:     true,
            allow_blank:  false,
            uniqueness:   { case_sensitive: false }

  validates :flight_count,
            numericality: { greater_than_or_equal_to: 0 },
            uniqueness:   { scope: :automatic },
            if: :automatic?

  validates :flight_count,
            presence: false,
            unless: :automatic?

  def to_s
    name
  end

  private

  def ensure_no_users
    return if users.empty?
    errors.add :users, 'are still dependent'
    throw :abort
  end
end
