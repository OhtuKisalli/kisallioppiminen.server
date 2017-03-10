require 'date'

class CourseService

  def self.find_by_coursekey(key)
    return Course.find_by(coursekey: key)
  end
  
  def self.course_has_exercise?(course, hid)
    return course.exercises.where(html_id: hid).any?
  end
  
  def self.all_courses
    return Course.all
  end
  
  def self.course_by_id(cid)
    return Course.where(id: cid).first
  end
  
  def self.coursekey_reserved?(key)
    return Course.where(coursekey: key).any?
  end
  
  def self.create_new_course(sid, params)
    @course = Course.new(params)
    if not coursekey_reserved?(@course.coursekey) and @course.save
      Teaching.create(user_id: sid, course_id: @course.id)
      return @course.id
    else
      return -1
    end
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
    return course.courseinfo_with_coursename
  end
  
  def self.update_course?(id, params)
    @course = Course.find(id)
    @course.coursekey = params[:coursekey]
    @course.name = params[:name]
    @course.startdate = params[:startdate]
    @course.enddate = params[:enddate]
    if @course.save
      return true 
    else
      return false
    end
  end
  
  def self.teacher_courses(id)
    courses = User.find(id).courses_to_teach
    if courses.empty?
      return {}
    else
      return build_coursehash(courses, "teacher", id)
    end
  end
  
  def self.student_courses(id)
    courses = User.find(id).courses
    return build_coursehash(courses, "student", id)
  end
  
  private
    def self.build_coursehash(courses, target, id)
      result = []
      courses.each do |c|
        courseinfo = c.courseinfo
        if target == "teacher"
          courseinfo["archived"] = Teaching.where(user_id: id, course_id: c.id).first.archived
        elsif target == "student"
          courseinfo["archived"] = Attendance.where(user_id: id, course_id: c.id).first.archived
        end
        result << courseinfo
      end
      return result
    end
  
  
end
