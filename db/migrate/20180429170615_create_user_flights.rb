class CreateUserFlights < ActiveRecord::Migration[5.1]
  def change
    create_table :user_flights, id: :uuid do |t|
      t.uuid     :user_id,           null: false
      t.uuid     :airline_flight_id, null: false
      t.uuid     :aircraft_type_id,  null: false
      t.datetime :time_out,          null: false
      t.datetime :time_off,          null: false
      t.datetime :time_on,           null: false
      t.datetime :time_in,           null: false
      t.text     :route,             null: false
      t.text     :remarks
      t.uuid     :network_id
      t.decimal  :duration, precision: 3, scale: 1, null: false
      t.boolean  :approved,       default: false
    end

    add_foreign_key :user_flights, :users
    add_foreign_key :user_flights, :airline_flights
    add_foreign_key :user_flights, :aircraft_types
    add_foreign_key :user_flights, :networks
  end
end
