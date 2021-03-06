# frozen_string_literal: true

class User::Rank < ApplicationRecord
  # Audits
  audited

  # ActiveRecord callbacks
  before_destroy :ensure_no_users

  # ActiveRecord associations
  has_many :users,
           class_name: 'User',
           inverse_of: :rank,
           dependent:  :destroy

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

  validates :order,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 },
            uniqueness: { case_sensitive: false }

  # Scopes
  default_scope { order(order: :asc) }

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
