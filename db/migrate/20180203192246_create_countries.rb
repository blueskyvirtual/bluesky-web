class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries, id: :uuid do |t|
      t.string :code, length: 2, unique: true, null: false
      t.string :name, null: false
    end

    add_index :countries, :code
  end
end
