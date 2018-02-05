class CreateRanks < ActiveRecord::Migration[5.1]
  def change
    create_table :ranks, id: :uuid do |t|
      t.string  :name, null: false, unique: true
      t.integer :flight_count
      t.boolean :automatic, default: false
    end
  end
end
