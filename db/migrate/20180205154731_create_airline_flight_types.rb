class CreateAirlineFlightTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :airline_flight_types, id: :uuid do |t|
      t.string :name, null: false, unique: true
    end

    add_column :airline_flights, :type_id, :uuid, null: false
  end
end
