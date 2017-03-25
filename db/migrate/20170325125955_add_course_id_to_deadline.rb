class AddCourseIdToDeadline < ActiveRecord::Migration[5.0]
  def change
    add_column :deadlines, :course_id, :integer
  
    Deadline.all.each do |d|
      if d.schedules.any?
        eid = d.schedules.first.exercise_id
        e = Exercise.where(id: eid).first
        d.course_id = e.course_id
        d.save
      else
        d.destroy
      end
		end
		
  end
end
