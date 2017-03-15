class ExerciseService

  # exercises {"1.1": "html_id1", "1.2": "html_id2"}
  # returns nothing
  def self.add_exercises_to_course(exercises, cid)
    exercises.each do |key, value|
      if Exercise.where(html_id: value, course_id: cid).empty?
        Exercise.create(html_id: value, course_id: cid)
      end
    end
  end
  
  # returns Exercise or nil
  def self.exercise_by_id(eid)
    return Exercise.where(id: eid).first
  end
  
  # returns []
  def self.exercise_ids_of_course(cid)
    return Exercise.where(course_id: cid).ids
  end
  
  # returns Exercise or nil
  def self.exercise_by_course_id_and_html_id(cid, hid)
    return Exercise.where(course_id: cid, html_id: hid).first
  end
  
  # exercises: ["html_id1", "html_id2"]
  def self.exercises_by_course_id_and_html_id_array(cid, exercises)
    return Exercise.where(course_id: cid, html_id: exercises)
  end
  
  #
  def self.create_exercise(cid, hid)
    Exercise.create(course_id: cid, html_id: hid)
  end
  
  #
  def self.all_exercises
    return Exercise.all
  end
end
