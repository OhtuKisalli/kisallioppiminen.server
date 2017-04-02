class ExercisesToExerciselists < ActiveRecord::Migration[5.0]
  def change
  
    hids = Course.all.map(&:html_id).uniq
    hids.each do |h|
      elist = Exerciselist.create(html_id: h)
      course = Course.where(html_id: h).first
      exs = Exercise.where(course_id: course.id)
      exs.each do |e|
        e.exerciselist_id = elist.id
        e.save
      end
    end
  
  end
end
