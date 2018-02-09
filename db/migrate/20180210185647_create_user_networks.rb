class CreateUserNetworks < ActiveRecord::Migration[5.1]
  def change
    create_table :user_networks, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :network_id, null: false
      t.string :username, null: false
    end
  end
end
