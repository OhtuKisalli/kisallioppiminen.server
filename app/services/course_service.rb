class CourseService

  def self.find_by_coursekey(key)
    return Course.find_by(coursekey: key)
  end
  
  def self.course_has_exercise?(course, hid)
    return course.exercises.where(html_id: hid).empty?
  end
  
  def self.student_checkmarks_course_info(sid, cid)
    result = {}
    course = Course.find(cid)
    result["html_id"] = course.html_id
    result["coursekey"] = course.coursekey
    result["archived"] = AttendanceService.student_course_archived?(sid, cid)
    return result
  end

end
