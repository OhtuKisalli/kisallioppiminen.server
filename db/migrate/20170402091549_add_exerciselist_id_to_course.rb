class AddExerciselistIdToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :exerciselist_id, :integer
  end
end
