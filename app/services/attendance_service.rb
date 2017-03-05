class AttendanceService

  def self.user_on_course?(sid, cid)
    return Attendance.where(user_id: sid, course_id: cid).any?
  end
  
  def self.student_course_archived?(sid, cid)
    return Attendance.where(user_id: sid, course_id: cid).first.archived
  end

end
