class UserService

  # returns []
  def self.all_users
    return User.order(:id)
  end

  # returns nil (no user) or []
  def self.teacher_courses(sid)
    user = give_user(sid)
    if user
      return user.courses_to_teach
    else
      return nil
    end
  end

  # returns nil (no user) or []
  def self.student_courses(id)
    student = give_user(id)
    if student
      return student.courses
    else
      return nil
    end
  end
  
  # returns User or nil
  def self.user_by_id(sid)
    return give_user(sid)
  end
  
  private
    def self.give_user(sid)
      return User.where(id: sid).first
    end

end
