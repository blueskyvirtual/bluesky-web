class AddDistanceAndDurationToAirlineFlights < ActiveRecord::Migration[5.1]
  def change
    add_column :airline_flights, :distance, :decimal, precision: 5, scale: 1, null: false
    add_column :airline_flights, :duration, :decimal, precision: 2, scale: 1, null: false
  end
end
