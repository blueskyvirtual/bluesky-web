# frozen_string_literal: true

class Aircraft::Type < ApplicationRecord
  # Audits
  audited

  # ActiveRecord validations
  validates :icao,
            presence:     true,
            allow_blank:  false,
            length:       { minimum: 2, maximum: 4 },
            uniqueness:   { case_sensitive: false }

  validates :iata, allow_blank: true, length: { maximum: 3 }
  validates :name, presence: true, allow_blank: false

  def iata=(str)
    str.nil? ? super(str) : super(str.upcase)
  end

  def icao=(str)
    str.nil? ? super(str) : super(str.upcase)
  end
end
