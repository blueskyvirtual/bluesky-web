class ChangeAirlineFlights < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :user_flights, :airline_flights
    drop_table :airline_flights

    create_table :airline_flights, id: :uuid do |t|
      t.uuid    :airline_id,       null: false
      t.integer :flight,           null: false
      t.uuid    :origin_id,        null: false
      t.uuid    :destination_id,   null: false
      t.time    :dep_time,         null: false
      t.time    :arv_time,         null: false
      t.uuid    :aircraft_type_id, null: false
    end

    add_index :airline_flights, :origin_id
    add_index :airline_flights, :destination_id

    add_foreign_key :airline_flights, :airports, column: :origin_id
    add_foreign_key :airline_flights, :airports, column: :destination_id
    add_foreign_key :airline_flights, :aircraft_types
  end
end
