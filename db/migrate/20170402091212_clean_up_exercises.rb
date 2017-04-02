class CleanUpExercises < ActiveRecord::Migration[5.0]
  def change
  
    Exercise.where(exerciselist_id: nil).destroy_all
    remove_column :exercises, :name
    remove_column :exercises, :course_id
  
  end
end
