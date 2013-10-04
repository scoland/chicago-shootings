class AddIndexToVictimsName < ActiveRecord::Migration
  def change
  	add_index :victims, :name
  end
end
