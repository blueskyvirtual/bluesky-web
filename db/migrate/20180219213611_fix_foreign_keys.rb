class FixForeignKeys < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :airline_fleets,  :airlines
    add_foreign_key :airline_fleets,  :aircraft_types
    add_foreign_key :airline_flights, :airline_fleets,       column: :fleet_id
    add_foreign_key :airline_flights, :airports,             column: :origin_id
    add_foreign_key :airline_flights, :airports,             column: :destination_id
    add_foreign_key :airline_flights, :airline_flight_types, column: :type_id
    add_foreign_key :airport_runways, :airports
    add_foreign_key :regions,         :countries
    add_foreign_key :user_networks,   :networks
    add_foreign_key :users,           :user_ranks,           column: :rank_id
    add_foreign_key :users,           :airports,             column: :home_airport_id
    add_foreign_key :users,           :user_statuses
    add_foreign_key :users,           :regions
  end
end
