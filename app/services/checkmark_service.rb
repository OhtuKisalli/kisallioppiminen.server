class CheckmarkService

  # checkmarks for student (one course)
  # returns array of JSONs [{},{},{},{}]
  # where JSON {"id":"exercise.html_id","status":"green/red/yellow/gray"}
  def self.student_checkmarks(cid, sid)
    exercises = ExerciseService.exercise_ids_of_course(cid)
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
    exercise = ExerciseService.exercise_by_course_id_and_html_id(cid, hid)
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
  
  def self.checkmarks_for_scoreboard(sid, exercises)
    return Checkmark.joins(:exercise).where(user_id: sid, exercise_id: exercises).select("exercises.html_id","status")
  end

  def self.all_checkmarks_count
    return Checkmark.all.count
  end
  
  def self.create_checkmark(sid, eid, status)
    @c = nil
    if Checkmark.where(user_id: sid, exercise_id: eid).empty?
      @c = Checkmark.create(user_id: sid, exercise_id: eid, status: status)
    end
    return @c
  end

end

