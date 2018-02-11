class CreateUserStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :user_statuses, id: :uuid do |t|
      t.string :name, null: false, unique: true
      t.boolean :allow_login, default: true
      t.boolean :show_on_roster, default: true
    end

    add_column :users, :user_status_id, :uuid, null: false
  end
end
