class TeachingService

  # returns true or false
  def self.teacher_on_course?(sid, cid)
    return Teaching.where(user_id: sid, course_id: cid).any?
  end
  
  # returns true or false
  def self.is_teacher?(sid)
    return Teaching.where(user_id: sid).any?
  end
  
  #
  def self.change_archived_status(sid, cid, status)
    t = Teaching.where(user_id: sid, course_id: cid).first
    if status == "false"
      t.archived = false
      t.save
    elsif status == "true"
      t.archived = true
      t.save
    end
  end
  
  # returns true or false
  def self.is_archived?(sid, cid)
    return Teaching.where(user_id: sid, course_id: cid).first.archived
  end
  
  #
  def self.create_teaching(sid, cid)
    Teaching.create(user_id: sid, course_id: cid)
  end
  
  # todo: update when assistants added to database
  def self.has_rights?(sid, cid)
    return teacher_on_course?(sid, cid)
  end
  
  #
  def self.all_teachings
    return Teaching.all
  end
  
  # returns number
  def self.number_of_teachings
    return Teaching.all.count
  end
  
  # returns how many courses user created today
  # sid = User.id
  def self.courses_created_today(sid)
    return Teaching.where(["created_at >= ? AND user_id = ?", Time.now.beginning_of_day, sid]).count
  end
  
  # TODO: update when assistants added
  # returns {177=>3, 178=>2, 179=>1, 180=>1} or {}
  def self.course_count_rank
    return Teaching.group('user_id').order('count_all DESC').count
  end
  
  # returns [12, 13, 14] or []
  def self.teacher_courses_ids(sid)
    Teaching.where(user_id: sid).map(&:course_id)
  end
  
end
