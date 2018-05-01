# frozen_string_literal: true

module ScheduleHelper
  def aircraft_options
    Airline::Flight.scheduled_aircraft_types.collect do |e|
      ["#{e.name} (#{e.icao})", e.icao]
    end
  end

  def airlines_options
    # options_from_collection_for_select(
    #   Airline.all.order(:name),
    #   :icao,
    #   :to_option_display
    # )
    # Note - using options_from_collection_for_select show above was
    # resulting in forms reverting to the blank value after submission. It
    # failed to reflect the currently selected option.
    #
    Airline.all.collect { |a| [a.to_option_display, a.icao] }
  end

  def origin_airport_options
    Airline::Flight.scheduled_origin_airports.collect do |a|
      [a.to_display, a.ident]
    end
  end

  def destination_airport_options
    Airline::Flight.scheduled_destination_airports.collect do |a|
      [a.to_display, a.ident]
    end
  end

  def flight_type_options
    Airline::Flight::Type.all.order(:name).collect do |type|
      [type.name, type.name]
    end
  end
end
