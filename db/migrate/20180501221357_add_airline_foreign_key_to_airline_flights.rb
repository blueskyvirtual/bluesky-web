class AddAirlineForeignKeyToAirlineFlights < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :airline_flights, :airlines
  end
end
