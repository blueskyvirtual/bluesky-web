class RenameRanks < ActiveRecord::Migration[5.1]
  def change
    rename_table :ranks, :user_ranks
  end
end
