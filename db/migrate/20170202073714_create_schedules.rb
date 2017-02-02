class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.integer :exercise_id
      t.integer :deadline_id

      t.timestamps
    end
  end
end
