class Scoreboard
    
  # Scoreboard for course
  # cid = Course.id
  def self.newboard(cid)
    course = Course.find(cid)
    board = course.courseinfo
    exercises = Exercise.where(course_id: cid).ids
    students = course.students
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
      exercisearray = []
      cmarks = Checkmark.joins(:exercise).where(user_id: s.id, exercise_id: exercises).select("exercises.html_id","status")
      cmarks.each do |c|
        h = {}
        h["id"] = c.html_id
        h["status"] = c.status
        exercisearray << h
      end
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

