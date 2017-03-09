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
  
  def self.all_deadlines
    return Deadline.all
  end
  
  def self.deadline_by_id(did)
    return Deadline.where(id: did).first
  end
  

end
