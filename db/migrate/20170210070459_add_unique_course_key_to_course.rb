class AddUniqueCourseKeyToCourse < ActiveRecord::Migration[5.0]
  def change
    add_index :courses, :coursekey, unique: true
  end
end
