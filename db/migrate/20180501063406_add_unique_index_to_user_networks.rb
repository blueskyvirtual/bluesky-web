class AddUniqueIndexToUserNetworks < ActiveRecord::Migration[5.1]
  def change
    add_index :user_networks, [:user_id, :network_id], unique: true
  end
end
