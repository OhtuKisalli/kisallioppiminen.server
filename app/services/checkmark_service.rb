class CheckmarkService

  # checkmarks for student (one course)
  # returns array of JSONs [{},{},{},{}]
  # where JSON {"id":"exercise.html_id","status":"green/red/yellow/gray"}
  def self.student_checkmarks(cid, sid)
    attendance = AttendanceService.get_attendance(sid, cid)
    checkmarks = []
    if attendance
      attendance.checkmarks.each do |key, value|
        checkmarks << {"id" => key, "status" => value}
      end
    end
    return checkmarks
  end
  
  # saves/updates student checkmark
  # params: sid (User.id), cid (Course.id), hid (Exercise.html_id), status ("green/red/yellow")
  # returns true if success
  def self.save_student_checkmark(sid, cid, hid, status)
    @a = AttendanceService.get_attendance(sid, cid)
    if @a and ExerciseService.exercise_on_course?(cid, hid)
      @a.checkmarks[hid] = status
      return @a.save
    else
      return false
    end
  end
  
  # Exercises that are not marked (green,yellow,red) are gray in scoreboards
  def self.add_gray_checkmarks(exercisearray, sid, cid)
    attendance = AttendanceService.get_attendance(sid, cid)
    exercises = ExerciseService.html_ids_of_exercises_by_course_id(cid)
    if attendance and exercises.size > 0
      done_exs_hash = attendance.checkmarks
      exercises.each do |html_id|
        if not done_exs_hash.key?(html_id)
          exercisearray << {"id" => html_id, "status" => "gray"}
        end
      end
    end
    return exercisearray
  end
  
  def self.all_checkmarks_count
    attendances = AttendanceService.all_attendances
    count = 0
    attendances.each do |a|
      count += a.checkmarks.size
    end
    return count
  end
  
  def self.get_checkmark_status(sid,cid,hid)
    a = AttendanceService.get_attendance(sid, cid)
    status = nil
    if a
      status = a.checkmarks[hid]
    end
    return status
  end
  
end

