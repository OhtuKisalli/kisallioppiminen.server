class TeacherService

  def self.teacher_on_course?(sid, cid)
    return Teaching.where(user_id: sid, course_id: cid).any?
  end
  
  def self.is_teacher?(sid)
    return Teaching.where(user_id: sid).any?
  end
  
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
  
  # todo: update when assistants added to database
  def self.has_rights?(sid, cid)
    return teacher_on_course?(sid, cid)
  end

end
