class ScoreboardService

  def self.build_student_scoreboard(cid, sid)
      checkmarks = CheckmarkService.student_checkmarks(cid, sid)
      course = CourseService.course_by_id(cid)
      scoreboard = course.courseinfo
      checkmarks = CheckmarkService.add_gray_checkmarks(checkmarks, sid, cid)
      scoreboard["exercises"] = checkmarks
      return scoreboard
  end
  
  def self.build_student_scoreboards(sid)
      courses = UserService.student_courses(sid)
      sb = []
      courses.each do |c|
        if not AttendanceService.student_course_archived?(sid, c.id)
          sb << build_student_scoreboard(c.id, sid)
        end
      end
      return sb
  end
  
  def self.build_scoreboards(sid)
    courses = UserService.teacher_courses(sid)
    sb = []
    courses.each do |c|
      sb << build_scoreboard(c.id)
    end
    return sb
  end
  
  # Scoreboard for course
  # cid = Course.id
  def self.build_scoreboard(cid)
    course = CourseService.course_by_id(cid)
    board = course.courseinfo
    #exercises = course.exercises.ids
    students = course.students.order(:last_name)
    count = 1
    studentlist = []
    students.each do |s|
      name = build_name(s)
      if name.blank?
        name = "Nimetön " + count.to_s
        count += 1
      end
      studentjson = {}
      studentjson["user"] = name
      exercisearray = CheckmarkService.student_checkmarks(cid, s.id)
      exercisearray = CheckmarkService.add_gray_checkmarks(exercisearray, s.id, cid)
      studentjson["exercises"] = exercisearray
      studentlist << studentjson
    end
    board["students"] = studentlist
    return board
  end
  
  private
    # "Lastname Firstname" or "Lastname" or "Firstname"
    def self.build_name(s)
      name = ""
      if not s.last_name.blank?
        name += s.last_name
      end
      if not name.blank? and not s.first_name.blank?
        name += " " + s.first_name
      elsif not s.first_name.blank?
        name += s.first_name
      end
      return name
    end
    
end
