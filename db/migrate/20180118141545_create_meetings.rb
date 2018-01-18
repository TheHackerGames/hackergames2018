class CreateMeetings < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
      t.integer :availability_id
      t.integer :user_id

      t.timestamps
    end
  end
end
