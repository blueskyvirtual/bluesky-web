class CreateAirlineFleets < ActiveRecord::Migration[5.1]
  def change
    create_table :airline_fleets, id: :uuid do |t|
      t.uuid :airline_id,       null: false
      t.uuid :aircraft_type_id, null: false
    end
  end
end
