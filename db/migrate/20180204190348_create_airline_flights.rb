class CreateAirlineFlights < ActiveRecord::Migration[5.1]
  def change
    create_table :airline_flights, id: :uuid do |t|
      t.uuid    :fleet_id,         null: false
      t.integer :flight,           null: false
      t.uuid    :origin_id,        null: false
      t.uuid    :destination_id,   null: false
      t.time    :dep_time,         null: false
      t.time    :arv_time,         null: false
    end

    add_index :airline_flights, :origin_id
    add_index :airline_flights, :destination_id
  end
end
