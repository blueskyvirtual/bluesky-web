# frozen_string_literal: true

class Airline::Flight < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  belongs_to :airline,      class_name: 'Airline', inverse_of: :flights
  belongs_to :origin,       class_name: 'Airport', inverse_of: :departures
  belongs_to :destination,  class_name: 'Airport', inverse_of: :arrivals

  belongs_to :aircraft_type,
             class_name: 'Aircraft::Type',
             inverse_of: :airline_flights

  belongs_to :flight_type,
             class_name: 'Airline::Flight::Type',
             inverse_of: :flights

  # ActiveRecord validations
  validates :flight,
            presence:     true,
            allow_blank:  false,
            numericality: { greater_than_or_equal_to: 0 }

  validates :dep_time, presence: true, allow_blank: false
  validates :arv_time, presence: true, allow_blank: false

  before_save :calculate_distance
  before_save :calculate_duration

  # calculates the distance in nautical miles between origin and dest
  #
  # ActiveRecord before save callback to calculate the distance between
  # origin and destination in nautical miles.
  #
  # Returns Float
  #
  def calculate_distance
    self.distance = origin.distance_from(destination, :nm)
  end

  # calculates the duration in hours between origin and dest
  #
  # ActiveRecord before save callback to calculate the duration between
  # origin and destination in hours as provided by the object's departure
  # and arrival time.
  #
  # Returns Float
  #
  def calculate_duration
    return unless dep_time_changed? || arv_time_changed?

    # compensate for departure times overnight
    self.duration = if dep_time > arv_time
                      next_day = arv_time + 1.day
                      TimeDifference.between(dep_time, next_day).in_hours
                    else
                      TimeDifference.between(dep_time, arv_time).in_hours
                    end
  end

  # Returns the flight as a display string ICAO#
  #  ex. UAL1234
  #
  def to_s
    "#{airline.icao}#{flight}"
  end

  # Returns an array of Aircraft::Types that have scheduled flights
  #
  def self.scheduled_aircraft_types
    select('DISTINCT(aircraft_type_id)')
      .joins(:aircraft_type)
      .select('aircraft_types.name')
      .order('aircraft_types.name')
      .collect(&:aircraft_type)
  end

  # Returns an array of Airports that have scheduled departures
  #
  def self.scheduled_origin_airports
    select('DISTINCT(origin_id)')
      .joins(:origin)
      .joins(origin: :region)
      .select('airports.municipality', 'regions.name')
      .order('airports.municipality', 'regions.name')
      .collect(&:origin)
  end

  # Returns an array of Airports that have scheduled arrivals
  #
  def self.scheduled_destination_airports
    select('DISTINCT(destination_id)')
      .joins(:destination)
      .joins(destination: :region)
      .select('airports.municipality', 'regions.name')
      .order('airports.municipality', 'regions.name')
      .collect(&:destination)
  end
end
