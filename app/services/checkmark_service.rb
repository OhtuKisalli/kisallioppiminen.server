class CheckmarkService

  # checkmarks for student (one course)
  # returns array of JSONs [{},{},{},{}]
  # where JSON {"id":"exercise.html_id","status":"green/red/yellow/gray"}
  def self.student_checkmarks(cid, sid)
    exercises = Exercise.where(course_id: cid).ids
    cmarks = Checkmark.joins(:exercise).where(user_id: sid, exercise_id: exercises).select("exercises.html_id","status")
    checkmarks = []
    cmarks.each do |c|
      checkmarks << {"id" => c.html_id, "status" => c.status}
    end
    return checkmarks
  end
  
  # saves/updates student checkmark
  # params: sid (User.id), cid (Course.id), hid (Exercise.html_id), status ("green/red/yellow")
  # returns true if success
  def self.save_student_checkmark(sid, cid, hid, status)
    exercise = Exercise.find_by(course_id: cid, html_id: hid)
      @checkmark = Checkmark.find_by(exercise_id: exercise.id, user_id: sid)
      if @checkmark.nil?
        @checkmark = Checkmark.new(user_id: sid, exercise_id: exercise.id)
      end
      @checkmark.status = status
      if @checkmark.save 
        return true 
      else
        return false
      end
  end

  def self.all_checkmarks_count
    return Checkmark.all.count
  end

end

