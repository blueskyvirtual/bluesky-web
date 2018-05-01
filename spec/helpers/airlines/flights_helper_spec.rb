# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Airlines::FlightsHelper. For example:
#
# describe Airlines::FlightsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Airlines::FlightsHelper, type: :helper do

  describe '#airport_code' do
    it 'returns the IATA code for an airport if it exists' do
      airport = create(:airport, iata: 'TST')
      expect(helper.airport_code(airport)).to eq 'TST'
    end

    it 'returns the ident code for an airport if IATA does not exist' do
      airport = create(:airport, iata: nil)
      expect(helper.airport_code(airport)).to eq airport.ident
    end
  end

  describe '#flight_duration' do
    it 'returns the duration of the flight in words' do
      dep_time = Time.rfc3339('2000-01-01T00:00:00-00:00')
      arv_time = Time.rfc3339('2000-01-01T02:16:00-00:00')
      flight = create(:airline_flight, dep_time: dep_time, arv_time: arv_time)
      expect(helper.flight_duration(flight)).to eq '2 hours and 16 minutes'
    end

    it 'returns the duration of the flight in words over midnight' do
      dep_time = Time.rfc3339('2000-01-01T22:00:00-00:00')
      arv_time = Time.rfc3339('2000-01-01T02:31:00-00:00')
      flight = create(:airline_flight, dep_time: dep_time, arv_time: arv_time)
      expect(helper.flight_duration(flight)).to eq '4 hours and 31 minutes'
    end
  end

end
