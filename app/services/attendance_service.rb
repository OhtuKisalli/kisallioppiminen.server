class AttendanceService

  # returns true or false
  def self.user_on_course?(sid, cid)
    return Attendance.where(user_id: sid, course_id: cid).any?
  end
  
  # returns true or false
  def self.student_course_archived?(sid, cid)
    return is_archived?(sid,cid)
  end
  
  # returns true or false
  def self.is_student?(sid)
    return Attendance.where(user_id: sid).any?
  end
  
  # returns []
  def self.all_attendances
    return Attendance.select(:user_id, :course_id, :archived, :checkmarks).order(:user_id)
  end
  
  # returns Attendance or nil
  def self.get_attendance(sid, cid)
    return Attendance.where(user_id: sid, course_id: cid).first
  end
  
  # returns number >= 0
  def self.students_on_course(cid)
    return Attendance.where(course_id: cid).count
  end
  
  #
  def self.leave_course(sid, cid)
    a = Attendance.where(user_id: sid, course_id: cid).first
    if a
      a.destroy
    end
  end
  
  # returns {}, keys: coursekeys, values: {} with keys "id","coursename","coursekey","html_id","startdate","enddate"
  def self.add_new_course_to_user(sid, cid)
    Attendance.create(user_id: sid, course_id: cid)
    courses = UserService.student_courses(sid)
    result = {}
    courses.each do |c|
      result[c.coursekey] = CourseService.basic_course_info(c)
    end
    return result
  end
  
  # returns true or false
  def self.is_archived?(sid, cid)
    return Attendance.where(user_id: sid, course_id: cid).first.archived
  end
  
  # returns true or false
  def self.create_attendance(sid, cid)
    @user = UserService.user_by_id(sid)
    @course = CourseService.course_by_id(cid)
    if @user and @course and not user_on_course?(sid, cid)
      Attendance.create(user_id: sid, course_id: cid, checkmarks: {})
      return true
    else
      return false
    end
  end
  
  # returns nothing
  def self.change_archived_status(sid, cid, status)
    a = Attendance.where(user_id: sid, course_id: cid).first
    if a and status == "false"
      a.archived = false
      a.save
    elsif a and status == "true"
      a.archived = true
      a.save
    end
  end

end
