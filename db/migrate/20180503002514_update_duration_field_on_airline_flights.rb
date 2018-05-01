class UpdateDurationFieldOnAirlineFlights < ActiveRecord::Migration[5.1]
  def change
    change_column :airline_flights, :duration, :decimal, precision: 3, scale: 1
  end
end
