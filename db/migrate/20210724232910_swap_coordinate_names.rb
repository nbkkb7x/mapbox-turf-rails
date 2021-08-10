class SwapCoordinateNames < ActiveRecord::Migration[6.0]
  def change
    rename_column :offices, :lat, :longitude
    rename_column :offices, :long, :latitude
  end
end
