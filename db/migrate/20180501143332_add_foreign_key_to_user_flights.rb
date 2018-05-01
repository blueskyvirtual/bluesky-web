class AddForeignKeyToUserFlights < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :user_flights, :airline_flights
  end
end
