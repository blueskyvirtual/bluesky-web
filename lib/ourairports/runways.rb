# frozen_string_literal: true

module OurAirports
  class Runways < Base
    DEFAULT_URL = 'http://ourairports.com/data/runways.csv'

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def self.import(url = DEFAULT_URL)
      super(url) do |entry|
        airport = Airport.find_by(ident: entry[:airport_ident])

        # Skip if airport not found
        next if airport.nil?

        runway = Airport::Runway.find_or_initialize_by(
          airport: airport,
          l_ident: entry[:le_ident],
          h_ident: entry[:he_ident]
        )

        # Dimensions
        runway.length = entry[:length_ft]
        runway.width  = entry[:width_ft]

        # Magnetic headings
        runway.l_heading = entry[:le_heading_degT].to_i
        runway.h_heading = entry[:he_heading_degT].to_i

        # Displaced thresholds
        runway.l_displaced_threshold = entry[:le_displaced_threshold_ft]
        runway.h_displaced_threshold = entry[:he_displaced_threshold_ft]

        # Starting points
        # rubocop:disable Metrics/LineLength
        runway.l_location = "POINT(#{entry[:le_longitude_deg]} #{entry[:le_latitude_deg]} #{entry[:le_elevation_ft]})"
        runway.h_location = "POINT(#{entry[:he_longitude_deg]} #{entry[:he_latitude_deg]} #{entry[:he_elevation_ft]})"
        # rubocop:enable Metrics/LineLength

        runway
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
