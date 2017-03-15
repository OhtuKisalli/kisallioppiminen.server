require 'date'

class CourseService

  # returns Course or nil
  def self.find_by_coursekey(key)
    return Course.find_by(coursekey: key)
  end
  
  # returns true or false
  def self.course_has_exercise?(course, hid)
    return course.exercises.where(html_id: hid).any?
  end
  
  # returns []
  def self.all_courses
    return Course.all
  end
  
  # returns Course or nil
  def self.course_by_id(cid)
    return Course.where(id: cid).first
  end
  
  # returns true or false
  def self.coursekey_reserved?(key)
    return Course.where(coursekey: key).any?
  end
  
  # returns id or -1
  def self.create_new_course(sid, params)
    @course = Course.new(params)
    if not coursekey_reserved?(@course.coursekey) and @course.save
      TeachingService.create_teaching(sid, @course.id)
      return @course.id
    else
      return -1
    end
  end
  
  # returns {}
  # keys: "coursekey","html_id","archived"
  def self.student_checkmarks_course_info(sid, cid)
    result = {}
    c = Course.find(cid)
    result["html_id"] = c.html_id
    result["coursekey"] = c.coursekey
    result["archived"] = AttendanceService.student_course_archived?(sid, cid)
    return result
  end
  
  # returns {}
  # keys: "id","coursename","coursekey","html_id","startdate","enddate"
  def self.basic_course_info(course)
    return course.courseinfo_with_coursename
  end
  
  # returns true or false
  def self.update_course?(id, params)
    @course = Course.find(id)
    @course.coursekey = params[:coursekey]
    @course.name = params[:name]
    @course.startdate = params[:startdate]
    @course.enddate = params[:enddate]
    if not coursekey_reserved?(@course.coursekey) and @course.save
      return true 
    else
      return false
    end
  end
  
  # returns [{},{},{}], [] when empty
  # JSON keys: "id", "coursekey", "html_id", "startdate", "enddate", "name", "archived"
  def self.teacher_courses(id)
    courses = UserService.teacher_courses(id)
    return build_coursehash(courses, "teacher", id)
  end
  
  # returns [{},{},{}], [] when empty
  # JSON keys: "id", "coursekey", "html_id", "startdate", "enddate", "name", "archived"
  def self.student_courses(id)
    courses = UserService.student_courses(id)
    return build_coursehash(courses, "student", id)
  end
  
  private
    def self.build_coursehash(courses, target, id)
      result = []
      courses.each do |c|
        courseinfo = c.courseinfo
        if target == "teacher"
          courseinfo["archived"] = TeachingService.is_archived?(id, c.id)
        elsif target == "student"
          courseinfo["archived"] = AttendanceService.is_archived?(id, c.id)
        end
        result << courseinfo
      end
      return result
    end
  
  
end
