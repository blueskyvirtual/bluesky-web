# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ScheduleHelper. For example:
#
# describe ScheduleHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ScheduleHelper, type: :helper do
  describe '#aircraft_options' do
    it 'creates an array of aircraft names and types for select options' do
      flight = create(:airline_flight)
      a      = flight.aircraft_type

      expect(helper.aircraft_options).to eq [["#{a.name} (#{a.icao})", a.icao]]
    end
  end

  describe '#airlines_options' do
    it 'creates an array of airlines' do
      airline = create(:airline)
      expect(helper.airlines_options).to eq [[airline.to_option_display, airline.icao]]
    end
  end

  describe '#origin_airport_options' do
    it 'creates an array of scheduled origin airports' do
      airport = create(:airport)
      create(:airline_flight, origin: airport)
      expect(helper.origin_airport_options).to eq [[airport.to_display, airport.ident]]
    end
  end

  describe '#destination_airport_options' do
    it 'creates an array of scheduled destination airports' do
      airport = create(:airport)
      create(:airline_flight, destination: airport)
      expect(helper.destination_airport_options).to eq [[airport.to_display, airport.ident]]
    end
  end

  describe '#flight_type_options' do
    it 'creates an array of flight types' do
      create(:airline_flight_type)
      arry = Airline::Flight::Type.all.order(:name).collect { |t| [t.name, t.name] }
      expect(helper.flight_type_options).to eq arry
    end
  end
end
