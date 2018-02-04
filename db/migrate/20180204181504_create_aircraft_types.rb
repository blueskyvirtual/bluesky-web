class CreateAircraftTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :aircraft_types, id: :uuid do |t|
      t.string :icao, length: 4, null: false, unique: true
      t.string :iata, length: 3
      t.string :name, null: false
    end

    add_index :aircraft_types, :icao
  end
end
