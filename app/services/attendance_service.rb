class AttendanceService

  def self.user_on_course?(sid, cid)
    return Attendance.where(user_id: sid, course_id: cid).any?
  end
  
  def self.student_course_archived?(sid, cid)
    return Attendance.where(user_id: sid, course_id: cid).first.archived
  end
  
  def self.all_attendances
    return Attendance.select(:user_id, :course_id, :archived).order(:user_id)
  end
  
  def self.add_new_course_to_user(sid, cid)
    Attendance.create(user_id: sid, course_id: cid)
    courses = User.find(sid).courses
    result = {}
    courses.each do |c|
      result[c.coursekey] = CourseService.basic_course_info(c)
    end
    return result
  end
  
  def self.change_archived_status(sid, cid, status)
    a = Attendance.where(user_id: sid, course_id: cid).first
    if status == "false"
      a.archived = false
      a.save
    elsif status == "true"
      a.archived = true
      a.save
    end
  end

end
