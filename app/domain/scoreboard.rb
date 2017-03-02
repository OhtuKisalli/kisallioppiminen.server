class Scoreboard
    
  # Scoreboard for course
  # cid = Course.id
  def self.newboard(cid)
    course = Course.find(cid)
    board = course.courseinfo
    exercises = course.exercises.ids
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
      exercisearray = add_gray_checkmarks(exercisearray, s, exercises, cid)
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
    
    def self.add_gray_checkmarks(array,s,course_exs,cid)
      not_done = course_exs - Checkmark.select(:exercise_id).where(user_id: s.id, exercise_id: course_exs).map(&:exercise_id)
      not_done_exercises = Exercise.where(id: not_done)
      not_done_exercises.each do |e|
        array << {"id" => e.html_id, "status" => "gray"}
      end     
      return array
    end
  
end

