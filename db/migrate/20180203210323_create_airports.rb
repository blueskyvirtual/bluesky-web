class CreateAirports < ActiveRecord::Migration[5.1]
  def change
    create_table :airports, id: :uuid do |t|
      t.string   :ident,        length: 4, null: false, unique: true
      t.string   :iata,         length: 3
      t.string   :name,         null: false
      t.string   :municipality
      t.uuid     :region_id,    null: false
      t.st_point :location,     geographic: true, has_z: true, null: false
    end

    add_index :airports, :ident
    add_index :airports, :iata
    add_index :airports, :location, using: :gist
  end
end
