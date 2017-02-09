class AddStartEndToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :startdate, :date
    add_column :courses, :enddate, :date
  end
end
