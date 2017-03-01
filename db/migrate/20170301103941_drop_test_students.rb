class DropTestStudents < ActiveRecord::Migration[5.0]
  def change
    drop_table :test_students
  end
end
