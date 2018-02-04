class CreateAirlines < ActiveRecord::Migration[5.1]
  def change
    create_table :airlines, id: :uuid do |t|
      t.string :icao, null: false, limit: 3, unique: true
      t.string :iata, limit: 3
      t.string :name, null: false
    end

    add_index :airlines, :icao
  end
end
