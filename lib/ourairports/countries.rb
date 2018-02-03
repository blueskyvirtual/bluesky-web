# frozen_string_literal: true

module OurAirports
  class Countries < Base
    DEFAULT_URL = 'http://ourairports.com/data/countries.csv'

    def self.import(url = DEFAULT_URL)
      super(url) do |entry|
        country = Country.find_or_initialize_by(code: entry[:code])
        country.name = entry[:name]
        country
      end
    end
  end
end
