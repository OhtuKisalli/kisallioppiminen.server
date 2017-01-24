class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :html_id
      t.string :coursekey
      t.string :name

      t.timestamps
    end
  end
end
