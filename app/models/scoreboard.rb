class Scoreboard
    
  def self.newboard(cid)
    board = {}
    course = Course.find(cid)
    exercises = Exercise.where(course_id: cid).ids
    students = course.students
    count = 1
    students.each do |s|
      cmarks = Checkmark.joins(:exercise).where(user_id: s.id, exercise_id: exercises).select("exercises.html_id","status")
      h = {}
      cmarks.each do |c|
        h[c.html_id] = c.status
      end
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
      elsif board.key?(name)
        name += count.to_s
        count += 1
      end
      board[name] = h
    end
    return board
  end
   
end

