# frozen_string_literal: true

class Region < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  belongs_to :country
  has_many   :airports, dependent: :destroy

  # ActiveRecord validations
  validates :code,
            presence:     true,
            allow_blank:  false,
            uniqueness:   { case_sensitive: false }

  validates :local_code,
            presence:     true,
            allow_blank:  false,
            uniqueness:   { case_sentitive: false, scope: :code }

  validates :name, presence: true, allow_blank: false

  def to_s
    "#{name} (#{local_code})"
  end
end
