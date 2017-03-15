class DeadlineService

  # exercises: ["html_id1", "html_id2"]
  # returns true or false
  def self.create_deadline(cid, description, deadline, exercises)
    @deadline = Deadline.new
    @deadline.description = description
    @deadline.deadline = deadline
    exs = ExerciseService.exercises_by_course_id_and_html_id_array(cid, exercises)
    @deadline.exercises << exs
    if @deadline.save
      return true
    else
      return false
    end
  end
  
  # returns true or false
  def self.deadline_on_course?(cid, did)
    deadline = Deadline.where(id: did).first
    if deadline and deadline.exercises.any? and CourseService.course_by_id(cid)
      return deadline.exercises.first.course.id == cid.to_i
    else
      return false
    end
  end
  
  # returns nothing
  def self.remove_deadline(did)
    Deadline.delete(did)
    schedules = Schedule.where(deadline_id: did)
    if schedules.size > 0
      schedules.destroy_all
    end
  end
  
  # returns []
  def self.all_deadlines
    return Deadline.all
  end
  
  # returns Deadline or nil
  def self.deadline_by_id(did)
    return Deadline.where(id: did).first
  end
  

end
