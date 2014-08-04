class AddWoeidToPlaces < ActiveRecord::Migration
  def change
  	add_column :places, :Woeid, :integer
  end
end
