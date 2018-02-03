# frozen_string_literal: true

module OurAirports
  class Regions < Base
    DEFAULT_URL = 'http://ourairports.com/data/regions.csv'

    def self.import(url = DEFAULT_URL)
      super(url) do |entry|
        region = Region.find_or_initialize_by(code: entry[:code])
        region.local_code   = entry[:local_code]
        region.name         = entry[:name]
        region.country      = Country.find_by(code: entry[:iso_country])
        region
      end
    end
  end
end
