class AddRegionToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :region_id, :uuid
  end
end
