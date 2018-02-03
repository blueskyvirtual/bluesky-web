# frozen_string_literal: true

class Country < ApplicationRecord
  # Audit
  audited

  # ActiveRecord associations
  has_many :regions, dependent: :destroy

  # ActiveRecord validations
  validates :code,
            presence:     true,
            allow_blank:  false,
            uniqueness:   { case_sensitive: false }

  validates :name, presence: true, allow_blank: false

  def to_s
    "#{name} (#{code})"
  end
end
