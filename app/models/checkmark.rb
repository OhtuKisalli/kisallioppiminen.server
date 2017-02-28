class Checkmark < ApplicationRecord

  belongs_to :user
  belongs_to :exercise
  
  #original one
  def self.student_checkmarks_old(cid, sid)
    @exercises = Exercise.where(course_id: cid).ids
    cmarks = Checkmark.joins(:exercise).where(user_id: sid, exercise_id: @exercises).select("exercises.html_id","status")
    checkmarks = {}
    cmarks.each do |c|
      checkmarks[c.html_id] = c.status
    end  
    return checkmarks
  end
  
  #new json format
  def self.student_checkmarks(cid, sid)
    @course = Course.find(cid)
    result = {}
    result["html_id"] = @course.html_id
    result["coursekey"] = @course.coursekey
    result["archived"] = Attendance.where(user_id: sid, course_id: cid).first.archived
    @exercises = Exercise.where(course_id: cid).ids
    cmarks = Checkmark.joins(:exercise).where(user_id: sid, exercise_id: @exercises).select("exercises.html_id","status")
    checkmarks = []
    cmarks.each do |c|
      checkmarks << {"id" => c.html_id, "status" => c.status}
    end
    result["exercises"] = checkmarks
    return result
  end

end
