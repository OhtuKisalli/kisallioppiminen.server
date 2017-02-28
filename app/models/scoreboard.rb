class Scoreboard
    
  #todo: refactor
  def self.newboard(cid)
    board = {}
    course = Course.find(cid)
    board["name"] = course.name
    board["coursekey"] = course.coursekey
    board["html_id"] = course.html_id
    board["startdate"] = course.startdate
    board["enddate"] = course.enddate
    exercises = Exercise.where(course_id: cid).ids
    students = course.students
    count = 1
    studentlist = []
    students.each do |s|
      name = ""
      if not s.last_name.blank?
        name += s.last_name
      end
      if not name.blank? and not s.first_name.blank?
        name += " " + s.first_name
      elsif not s.first_name.blank?
        name += s.first_name
      end
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
   
end

