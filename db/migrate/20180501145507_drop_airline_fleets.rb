class DropAirlineFleets < ActiveRecord::Migration[5.1]
  def change
    drop_table :airline_fleets
  end
end
