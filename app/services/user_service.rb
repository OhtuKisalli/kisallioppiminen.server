class UserService

  def self.all_users
    return User.all
  end

  def self.teacher_courses(id)
    return User.find(id).courses_to_teach
  end

  def self.student_courses(id)
    return User.find(id).courses
  end

end
