class PutCheckmarksToJson < ActiveRecord::Migration[5.0]
  
  def change
    add_column :attendances, :checkmarks, :json, null: false, default: {}
    Attendance.all.each do |a|
      cms = {}
      exs_ids = Exercise.where(course_id: a.course_id).ids
      cmarks = Checkmark.where(user_id: a.user_id, exercise_id: exs_ids)
      cmarks.each do |c|
        html_id = Exercise.find(c.exercise_id).html_id
        cms[html_id] = c.status
      end
      a.checkmarks = cms
      a.save
      cmarks.destroy_all
    end
  end
  
end
