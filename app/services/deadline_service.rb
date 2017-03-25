class DeadlineService

  # exercises: ["html_id1", "html_id2"]
  # returns true or false
  def self.create_deadline(cid, description, deadline, exercises)
    @deadline = Deadline.new
    @deadline.description = description
    @deadline.deadline = deadline
    @deadline.course_id = cid
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
    return Deadline.where(id: did, course_id: cid).any?
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
  
  # returns nothing
  def self.remove_deadlines_of_course(cid)
    Deadline.where(course_id: cid).destroy_all
  end
  

end
