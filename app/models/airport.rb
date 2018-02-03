# frozen_string_literal: true

class Airport < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  belongs_to :region

  has_many   :runways,
             class_name: 'Airport::Runway',
             dependent: :destroy,
             inverse_of: :airport

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

  # Displays the municipality (city) (or airport name if missing)
  def city
    return municipality if municipality.present?
    name
  end

  # Displays the city (local_code)
  def to_display
    "#{city}, #{region.local_code} (#{ident})"
  end

  def to_s
    "#{name} (#{ident})"
  end
end
