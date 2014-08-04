class AddTrendsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :trends, :text
  end
end
