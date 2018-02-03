class CreateAirportRunways < ActiveRecord::Migration[5.1]
  def change
    create_table :airport_runways, id: :uuid do |t|
      t.uuid :airport_id, null: false
      t.string  :l_ident, length: 3, null: false
      t.string  :h_ident, length: 3
      t.integer :length,  null: false
      t.integer :width
      t.integer :l_heading, size: 2, default: 0
      t.integer :h_heading, size: 2, default: 0
      t.integer :l_displaced_threshold, size: 2
      t.integer :h_displaced_threshold, size: 2
      t.st_point :l_location, geographic: true, has_z: true
      t.st_point :h_location, geographic: true, has_z: true
    end
  end
end
