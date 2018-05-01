class AddAirlineFlightTypeToAirlineFlights < ActiveRecord::Migration[5.1]
  def change
    add_column :airline_flights, :flight_type_id, :uuid, null: false

    add_foreign_key :airline_flights, :airline_flight_types, column: :flight_type_id
  end
end
