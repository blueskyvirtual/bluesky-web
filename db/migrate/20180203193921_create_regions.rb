class CreateRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :regions, id: :uuid do |t|
      t.string :code,       length: 6, unique: true, null: false
      t.string :local_code, length: 3, null: false
      t.string :name,       null: false
      t.uuid   :country_id, null: false
    end

    add_index :regions, :code
    add_index :regions, :local_code
  end
end
