class ScheduleService

  #
  def self.all_schedules
    return Schedule.all
  end
  
  #
  def self.count
    return Schedule.count
  end
  
  #
  def self.name_reserved?(cid, name)
    return Schedule.where(course_id: cid, name: name).any?
  end
  
  # [{},{},{}] or []
  # where {"id": 1, "name":"Tavoite1", "color": 1, "exercises": ["html_id1", "html_id2"]}
  def self.course_schedules(cid)
    course = Course.where(id: cid).first
    if not course or course.schedules.empty?
      return []
    end
    result = []
    course.schedules.each do |s|
      result << {"id": s.id, "name": s.name,"color": s.color, "exercises": s.exercises}
    end
    return result
  end
  
  #
  def self.add_new_schedule(cid, name, color)
    course = CourseService.course_by_id(cid)
    schedule = Schedule.new(course_id: cid, name: name, color: color)
    if course and not name_reserved?(cid, name) and schedule.save
      return true;
    else
      return false;
    end
  end
  
  # cid = Course.id
  # schedules: {
  # "1" : {"ex_html_id1" : true, "ex_html_id2" : false},
  # "2" : { },
  # "3" : {"ex_html_id3" : false}}
  def self.update_schedule_exercises(cid, schedules)
    course = CourseService.course_by_id(cid)
    if not course
      return false
    end
    schedules.each do |key, value|
      update_schedule_exercise(key.to_i, value)
    end
    return true
  end
  
  #
  def self.delete_schedule(id)
    Schedule.delete(id)
  end
  
  # returns true or false
  def self.schedule_on_course?(cid, id)
    return Schedule.where(id: id, course_id: cid).any?
  end
  
  private
    def self.update_schedule_exercise(sid, value)
      @schedule = Schedule.where(id: sid).first
      if @schedule
        exs = @schedule.exercises
        value.each do |k, v|
          if (v == "true" or v == true) and not exs.include? k
            exs << k  
          elsif (v == "false" or v == false) and exs.include? k
            exs.delete(k)
          end
        end
        @schedule.exercises = exs
        @schedule.save
      end
    end
  
end
