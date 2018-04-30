# frozen_string_literal: true

class Country < ApplicationRecord
  # Audit
  audited

  # FriendlyID configuration
  extend FriendlyId
  friendly_id :code

  # ActiveRecord associations
  has_many :regions, dependent: :destroy

  # ActiveRecord validations
  validates :code,
            presence:     true,
            allow_blank:  false,
            uniqueness:   { case_sensitive: false }

  validates :name, presence: true, allow_blank: false

  # Scopes
  default_scope { order(:name) }

  def to_s
    "#{name} (#{code})"
  end
end
