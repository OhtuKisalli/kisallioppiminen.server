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

end
