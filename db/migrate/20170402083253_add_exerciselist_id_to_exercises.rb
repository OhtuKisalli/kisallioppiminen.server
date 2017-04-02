class AddExerciselistIdToExercises < ActiveRecord::Migration[5.0]
  def change
    add_column :exercises, :exerciselist_id, :integer
  end
end
