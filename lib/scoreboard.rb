class Scoreboard
  attr_accessor :board
  
  def initialize(key)
    @board = {}
    course = Course.find_by(coursekey: key)
    @exercises = Exercise.where(course_id: course.id).ids
    students = course.students
    students.each do |s|
      cmarks = Checkmark.joins(:exercise).where(user_id: s.id, exercise_id: @exercises).select("exercises.html_id","status")
      h = {}
      cmarks.each do |c|
        h[c.html_id] = c.status
      end
      @board[s.name] = h
    end
  end
   
end

