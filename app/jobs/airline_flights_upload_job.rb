# frozen_string_literal: true

#
# This job accepts input from the airline flight upload
# action cable as a base64 encoded data uri.
#
# It will search for existing flights and update them or
# create a new flight if one does not exist yet.
#

require 'csv'

class AirlineFlightsUploadJob < ApplicationJob
  queue_as :default

  def perform(base64, channel = nil)
    @channel = channel
    @percent = 0 # completion factor

    action_cable_log('AirlineFlightsUploadJob Started')

    # Decode
    csv = decode(base64)
    # Parse
    list = parse(csv)
    # Process
    process(list)

    action_cable_log('AirlineFlightsUploadJob Finished')
  rescue StandardError => e
    action_cable_log("ERROR: #{e}")
  end

  private

  # Log to the action cable that initiated this job
  #
  def action_cable_log(msg)
    return if @channel.blank?
    msg = "#{Time.now.utc} -- #{msg}" if msg.present?
    ActionCable.server.broadcast @channel,
                                 message:  msg,
                                 progress: @percent.to_i
  end

  # Builds attributes array from CSV row data
  #
  def build_attributes(row)
    {
      airline:        find_airline(row['airline']),
      flight:         row['flight'],
      origin:         find_airport(row['origin']),
      destination:    find_airport(row['destination']),
      aircraft_type:  find_aircraft(row['aircraft_type']),
      dep_time:       row['dep_time'],
      arv_time:       row['arv_time'],
      flight_type:    find_flight_type(row['flight_type'])
    }
  end

  # The FileReader JS script encodes to base64, however the
  # "data:*/*;base64," must be removed in order to successfully decode
  #
  def decode(base64)
    action_cable_log('Decoding upload...')
    Base64.decode64(base64.match(/^.+,(.*)$/)[1])
  end

  # Lookup aircraft type
  #
  def find_aircraft(text)
    a = Aircraft::Type.find_by(iata: text) || Aircraft::Type.find_by(icao: text)
    action_cable_log("Unable to find aircraft: #{text}") if a.blank?
    a
  end

  # Lookup an airline
  #
  def find_airline(text)
    a = Airline.find_by(icao: text) || Airline.find_by(iata: text)
    action_cable_log("Unable to find airline: #{text}") if a.blank?
    a
  end

  # Lookup an airport
  #
  def find_airport(text)
    a = Airport.find_by(ident: text) || Airport.find_by(iata: text)
    action_cable_log("Unable to find airport: #{text}") if a.blank?
    a
  end

  # Lookup an existing flight by airline, number, origin, destination
  #
  def find_flight(attributes)
    search_params = attributes.slice(
      :airline, :flight, :origin, :destination, :flight_type
    )

    Airline::Flight.find_by(search_params)
  end

  # Look up the schedule type for the entry
  #
  def find_flight_type(text)
    type = Airline::Flight::Type.find_by(name: text)
    type = Airline::Flight::Type.find_by(name: 'Scheduled') if type.blank?
    type
  end

  # Parse the CSV into an array of Hashes
  #
  def parse(csv)
    action_cable_log('Parsing CSV file...')
    result = CSV.parse(csv.strip, headers: true).collect { |r| r }
    action_cable_log("File contains #{result.size} rows")
    result
  end

  # Process the csv entries
  #
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def process(array)
    progress = 0
    action_cable_log('Processing entries...')

    Airline::Flight.auditing_enabled = false # disable auditing for bulk upload

    array.each do |row|
      attributes = build_attributes(row)

      # Do not use find or create because we are limiting attribute search
      flight = find_flight(attributes) || Airline::Flight.new(attributes)

      if flight.changed?
        if flight.update_attributes(attributes)
          action_cable_log("Saved: #{flight}")
        else
          flt = "#{row['airline']}#{row['flight']}"
          action_cable_log("Cant save #{flt}: #{flight.errors.full_messages}")
        end
      end

      @percent = (((progress += 1) / array.size.to_f) * 100).round
      action_cable_log(nil) # update percent without message
    rescue StandardError => e
      action_cable_log("RUBY ERROR: #{e}")
      next
    end

    Airline::Flight.auditing_enabled = true # re-enable auditing
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
