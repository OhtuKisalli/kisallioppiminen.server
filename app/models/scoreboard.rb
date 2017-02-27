class Scoreboard
    
  def self.newboard(cid)
    board = {}
    course = Course.find(cid)
    exercises = Exercise.where(course_id: cid).ids
    students = course.students
    students.each do |s|
      cmarks = Checkmark.joins(:exercise).where(user_id: s.id, exercise_id: exercises).select("exercises.html_id","status")
      h = {}
      cmarks.each do |c|
        h[c.html_id] = c.status
      end
      name = s.last_name + " " + s.first_name
      board[name] = h
    end
    return board
  end
   
end

