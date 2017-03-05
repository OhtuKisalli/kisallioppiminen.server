require 'date'

class CourseService

  def self.find_by_coursekey(key)
    return Course.find_by(coursekey: key)
  end
  
  def self.course_has_exercise?(course, hid)
    return course.exercises.where(html_id: hid).empty?
  end
  
  def self.student_checkmarks_course_info(sid, cid)
    result = {}
    c = Course.find(cid)
    result["html_id"] = c.html_id
    result["coursekey"] = c.coursekey
    result["archived"] = AttendanceService.student_course_archived?(sid, cid)
    return result
  end
  
  def self.basic_course_info(course)
    courseinfo = {}
    courseinfo["coursename"] = course.name
    courseinfo["id"] = course.id
    courseinfo["coursekey"] = course.coursekey
    courseinfo["html_id"] = course.html_id
    courseinfo["startdate"] = course.startdate.to_s
    courseinfo["enddate"] = course.enddate.to_s
    return courseinfo
  end

end
