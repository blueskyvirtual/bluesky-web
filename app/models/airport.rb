# frozen_string_literal: true

class Airport < ApplicationRecord
  # Audits
  audited

  # FriendlyID configuration
  extend FriendlyId
  friendly_id :ident

  # ActiveRecord associations
  belongs_to :region

  has_many   :users,
             foreign_key: :home_airport_id,
             inverse_of: :home_airport,
             dependent: :nullify

  has_many :arrivals,
           class_name:  'Airline::Flight',
           foreign_key: :destination_id,
           inverse_of:  :destination,
           dependent:   :destroy

  has_many :departures,
           class_name:  'Airline::Flight',
           foreign_key: :origin_id,
           inverse_of:  :origin,
           dependent:   :destroy

  has_many :runways,
           class_name: 'Airport::Runway',
           inverse_of: :airport,
           dependent:  :destroy

  # ActiveRecord validations
  validates :ident,
            presence:     true,
            allow_blank:  false,
            length:       { maximum: 4 },
            uniqueness:   { case_sensitive: false }

  validates :iata,          length: { maximum: 3 }
  validates :name,          presence: true, allow_blank: false
  validates :location,      presence: true, allow_blank: false

  # ActiveRecord Delegations
  delegate :country, to: :region

  # Geocoding
  reverse_geocoded_by :latitude, :longitude

  # Displays the municipality (city) (or airport name if missing)
  def city
    return municipality if municipality.present?
    name
  end

  def latitude
    location.lat
  end

  def longitude
    location.lon
  end

  # Displays the city, state (ident)
  def to_display
    # "#{city}, #{region.local_code} (#{ident})"
    "#{to_municipality_display} (#{ident})"
  end

  # Displays the City, State
  #
  def to_municipality_display
    if country.code == 'US'
      "#{city}, #{region.local_code}"
    else
      "#{city}, #{country.code}"
    end
  end

  def to_s
    "#{name} (#{ident})"
  end
end
