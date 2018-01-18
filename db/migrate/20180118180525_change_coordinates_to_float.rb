class ChangeCoordinatesToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :availabilities, :latitude, :float
    change_column :availabilities, :longitude, :float
  end
end
