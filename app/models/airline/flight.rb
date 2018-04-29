# frozen_string_literal: true

class Airline::Flight < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  belongs_to :fleet,        class_name: 'Airline::Fleet', inverse_of: :flights
  belongs_to :origin,       class_name: 'Airport', inverse_of: :departures
  belongs_to :destination,  class_name: 'Airport', inverse_of: :arrivals

  belongs_to :type,
             class_name: 'Airline::Flight::Type',
             inverse_of: :flights

  has_many :user_flights,
           class_name: 'User::Flight',
           inverse_of: :airline_flight,
           dependent: :destroy

  # ActiveRecord validations
  validates :flight,
            presence:     true,
            allow_blank:  false,
            numericality: { greater_than_or_equal_to: 0 }

  validates :dep_time, presence: true, allow_blank: false
  validates :arv_time, presence: true, allow_blank: false

  # Delegations
  delegate :airline, to: :fleet
end
