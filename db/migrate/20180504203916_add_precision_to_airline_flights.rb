class AddPrecisionToAirlineFlights < ActiveRecord::Migration[5.1]
  def change
    change_column :airline_flights, :distance, :decimal, precision: 6, scale: 1
  end
end
