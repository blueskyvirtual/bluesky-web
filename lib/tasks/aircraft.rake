require 'csv'

namespace :aircraft do

  desc 'Import aircraft types into the database'
  task import: :environment do
    CSV.foreach(Rails.root.join( 'lib', 'assets', 'aircraft_types.csv'),
                headers: true,
                header_converters: :symbol
    ) do |row|

      type = Aircraft::Type.find_or_initialize_by(icao: row[:icao])
      type.iata = row[:iata]
      type.name = row[:name]
      type.save_without_auditing
    end
  end

end
