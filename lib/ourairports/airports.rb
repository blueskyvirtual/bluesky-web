# frozen_string_literal: true

module OurAirports
  class Airports < Base
    DEFAULT_URL = 'http://ourairports.com/data/airports.csv'

    def self.import(url = DEFAULT_URL)
      super(url) do |entry|
        airport = Airport.find_or_initialize_by(ident: entry[:ident])
        airport.iata          = entry[:iata_code]
        airport.name          = entry[:name]
        airport.municipality  = entry[:municipality]
        airport.region        = Region.find_by(code: entry[:iso_region])

        # rubocop:disable Metrics/LineLength
        airport.location = "POINT(#{entry[:longitude_deg]} #{entry[:latitude_deg]} #{entry[:elevation_ft]})"
        # rubocop:enable Metrics/LineLength

        airport
      end
    end
  end
end
