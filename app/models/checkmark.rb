class Checkmark < ApplicationRecord

  belongs_to :user
  belongs_to :exercise
  
  def self.student_checkmarks(cid, sid)
    @exercises = Exercise.where(course_id: cid).ids
    cmarks = Checkmark.joins(:exercise).where(user_id: sid, exercise_id: @exercises).select("exercises.html_id","status")
    checkmarks = []
    cmarks.each do |c|
      checkmarks << {"id" => c.html_id, "status" => c.status}
    end
    return checkmarks
  end

end
