class ScheduleService

  #
  def self.create_schedule(eid, did)
    Schedule.create(exercise_id: eid, deadline_id: did)
  end
  
  #
  def self.all_schedules
    return Schedule.all
  end
  
  #
  def self.number_of_schedules
    return Schedule.all.count
  end

end
