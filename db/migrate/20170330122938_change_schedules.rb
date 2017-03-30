class ChangeSchedules < ActiveRecord::Migration[5.0]
  def up
  
    Schedule.destroy_all

    remove_column :schedules, :exercise_id
    remove_column :schedules, :deadline_id
    
    add_column :schedules, :course_id, :integer
    add_column :schedules, :name, :string
    add_column :schedules, :exercises, :string, array: true, default: [], null: false
  
  end
  
  def down
    add_column :schedules, :exercise_id, :integer
    add_column :schedules, :deadline_id, :integer
    remove_column :schedules, :course_id
    remove_column :schedules, :name
    remove_column :schedules, :exercises
  
  end
end
