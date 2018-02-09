class CreateNetworks < ActiveRecord::Migration[5.1]
  def change
    create_table :networks, id: :uuid do |t|
      t.string :name, null: false
      t.text   :url
      t.text   :status_url
    end
  end
end
