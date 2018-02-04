# frozen_string_literal: true

class Airline::Fleet < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  belongs_to :airline
  belongs_to :aircraft_type, class_name: 'Aircraft::Type', inverse_of: :fleets

  has_many :flights,
           class_name:  'Airline::Flight',
           foreign_key: :fleet_id,
           inverse_of:  :fleet,
           dependent:   :destroy

  # ActiveRecord validations
  validates :aircraft_type, uniqueness: { scope: :airline }
end
