class AddSpotToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :spot, :integer
  end
end
