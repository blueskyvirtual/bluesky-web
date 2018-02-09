class UpdatePilotId < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :pilot_id, :serial
    remove_column :users, :slug, :string
    add_column :users, :pilot_id, :string, null: false, unique: true
  end
end
