class CreateExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises do |t|
      t.string :html_id
      t.string :name
      t.integer :course_id

      t.timestamps
    end
  end
end
