class CreateAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :availabilities do |t|
      t.integer :user_id

      t.string :name
      t.string :address
      t.integer :latitude
      t.integer :longitude
      t.string :gmaps_place_id

      t.datetime :start_datetime
      t.datetime :end_datetime

      t.timestamps
    end
  end
end
