# frozen_string_literal: true

class Airline < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  has_many :fleets,
           class_name: 'Airline::Fleet',
           inverse_of: :airline,
           dependent:  :destroy

  has_many :aircraft_types, through: :fleets

  # ActiveRecord validations
  validates :icao,
            presence:     true,
            allow_blank:  false,
            length:       { minimum: 3, maximum: 3 },
            uniqueness:   { case_sensitive: false }

  validates :iata, allow_blank: true, length: { minimum: 2, maximum: 3 }
  validates :name, presence: true, allow_blank: false

  def iata=(str)
    str.nil? ? super(str) : super(str.upcase)
  end

  def icao=(str)
    str.nil? ? super(str) : super(str.upcase)
  end
end
