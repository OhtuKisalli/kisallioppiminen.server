class TeacherService

  def self.teacher_on_course?(sid, cid)
    return Teaching.where(user_id: sid, course_id: cid).any?
  end

end
