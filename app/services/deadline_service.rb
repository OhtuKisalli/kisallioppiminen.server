class DeadlineService

  def self.create_deadline(cid, description, deadline, exercises)
    @deadline = Deadline.new
    @deadline.description = description
    @deadline.deadline = deadline
    exs = Exercise.where(course_id: cid, html_id: exercises)
    @deadline.exercises << exs
    if @deadline.save
      return true
    else
      return false
    end
  end
  
  def self.deadline_on_course?(cid, did)
    deadline = Deadline.where(id: did).first
    if deadline and deadline.exercises.any? and Course.where(id: cid).first
      return deadline.exercises.first.course.id == cid.to_i
    else
      return false
    end
  end
  
  def self.remove_deadline(did)
    Deadline.delete(did)
    Schedule.where(deadline_id: did).destroy_all
  end
  
  def self.all_deadlines
    return Deadline.all
  end
  
  def self.deadline_by_id(did)
    return Deadline.where(id: did).first
  end
  

end
