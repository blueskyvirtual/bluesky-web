# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airline::Flight, type: :model do
  it 'has a valid factory' do
    expect(build(:airline_flight)).to be_valid
  end

  let(:flight) { build(:airline_flight) }

  describe 'ActiveRecord associations' do
    it { expect(flight).to belong_to(:airline) }
    it { expect(flight).to belong_to(:origin) }
    it { expect(flight).to belong_to(:destination) }
    it { expect(flight).to belong_to(:flight_type) }
  end

  describe 'ActiveRecord validations' do
    # Basic validations
    it { expect(flight).to validate_presence_of(:flight) }
    it { expect(flight).to validate_presence_of(:dep_time) }
    it { expect(flight).to validate_presence_of(:arv_time) }

    # Format validations
    it { expect(flight).to_not allow_value('').for(:flight) }
    it { expect(flight.dep_time.class).to eq ActiveSupport::TimeWithZone }
    it { expect(flight.arv_time.class).to eq ActiveSupport::TimeWithZone }

    # Inclusion/acceptance of values
    it { expect(flight).to validate_numericality_of(:flight).is_greater_than_or_equal_to(0) }
  end
  # describe 'ActiveRecord validations'

  describe '#calculate_distance' do
    it 'calculates the distance in nm between origin and destination' do
      expect(create(:airline_flight).distance).to be > 0
    end
  end

  describe '#calculate_duration' do
    it 'calculates the duration in hours' do
      flight = create(:airline_flight, dep_time: '00:00', arv_time: '03:30')
      expect(flight.duration).to eq 3.5
    end

    it 'properly calculates the duration over midnight' do
      flight = create(:airline_flight, dep_time: '22:00', arv_time: '02:00')
      expect(flight.duration).to eq 4.0
    end
  end

  describe '#self.scheduled_aircraft_types' do
    before :each do
      create_list(:airline_flight, 5)
    end

    it 'returns an array of the Aircraft::Types for Airline::Flights flights' do
      Airline::Flight.scheduled_aircraft_types.each do |t|
        expect(t.class).to eq Aircraft::Type
      end
    end
  end

  describe '#self.scheduled_origin_airports' do
    before :each do
      create_list(:airline_flight, 5)
    end

    it 'returns an array of Airports for origins in Airline::Flights' do
      Airline::Flight.scheduled_origin_airports.each do |a|
        expect(a.class).to eq Airport
      end
    end
  end

  describe '#self.scheduled_destination_airports' do
    before :each do
      create_list(:airline_flight, 5)
    end

    it 'returns an array of Airports for destinations in Airline::Flights' do
      Airline::Flight.scheduled_destination_airports.each do |a|
        expect(a.class).to eq Airport
      end
    end
  end

  describe '#to_s' do
    it 'displays the ICAO flight callsign string' do
      expect(flight.to_s).to eq "#{flight.airline.icao}#{flight.flight}"
    end
  end
end
