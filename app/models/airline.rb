# frozen_string_literal: true

class Airline < ApplicationRecord
  # Audits
  audited

  # FriendlyID configuration
  extend FriendlyId
  friendly_id :icao

  # ActiveRecord associations
  has_many :flights, dependent: :destroy

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

  # Display ICAO - Airline name
  #
  # Used in helpers to collect form options like
  # schedule searching
  #
  def to_option_display
    "#{icao} - #{name}"
  end
end
