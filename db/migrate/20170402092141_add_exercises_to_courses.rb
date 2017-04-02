class AddExercisesToCourses < ActiveRecord::Migration[5.0]
  def change
  
    courses = Course.all
    courses.each do |c|
      elist = Exerciselist.where(html_id: c.html_id).first
      c.exerciselist_id = elist.id
      c.save
    end
  
  end
end
