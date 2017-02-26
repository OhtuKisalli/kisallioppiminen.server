class Scoreboard
  attr_accessor :board
  
  def initialize(cid)
    @board = {}
    course = Course.find(cid)
    exercises = Exercise.where(course_id: cid).ids
    students = course.students
    students.each do |s|
      cmarks = Checkmark.joins(:exercise).where(user_id: s.id, exercise_id: exercises).select("exercises.html_id","status")
      h = {}
      cmarks.each do |c|
        h[c.html_id] = c.status
      end
      @board[s.name] = h
    end
  end
  
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
      board[s.name] = h
    end
    return board
  end
   
end

