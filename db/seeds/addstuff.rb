Teaching.create(user_id: 2, course_id: 1)
Teaching.create(user_id: 2, course_id: 2)
Teaching.create(user_id: 3, course_id: 2)
Teaching.create(user_id: 4, course_id: 2)

#course1 attendances
Attendance.create(user_id: 5, course_id: 1)
Attendance.create(user_id: 6, course_id: 1)
Attendance.create(user_id: 7, course_id: 1)
Attendance.create(user_id: 8, course_id: 1)
Attendance.create(user_id: 9, course_id: 1)
Attendance.create(user_id: 10, course_id: 1)
Attendance.create(user_id: 11, course_id: 1)
Attendance.create(user_id: 12, course_id: 1)
Attendance.create(user_id: 13, course_id: 1)
Attendance.create(user_id: 14, course_id: 1)
Attendance.create(user_id: 15, course_id: 1)
Attendance.create(user_id: 16, course_id: 1)
Attendance.create(user_id: 17, course_id: 1)
Attendance.create(user_id: 18, course_id: 1)
Attendance.create(user_id: 19, course_id: 1)
Attendance.create(user_id: 20, course_id: 1)
Attendance.create(user_id: 21, course_id: 1)
Attendance.create(user_id: 22, course_id: 1)
Attendance.create(user_id: 23, course_id: 1)
Attendance.create(user_id: 24, course_id: 1)
Attendance.create(user_id: 25, course_id: 1)
Attendance.create(user_id: 26, course_id: 1)
Attendance.create(user_id: 27, course_id: 1)
Attendance.create(user_id: 28, course_id: 1)
Attendance.create(user_id: 29, course_id: 1)
Attendance.create(user_id: 30, course_id: 1)
Attendance.create(user_id: 31, course_id: 1)
Attendance.create(user_id: 32, course_id: 1)
Attendance.create(user_id: 33, course_id: 1)
Attendance.create(user_id: 34, course_id: 1)
Attendance.create(user_id: 35, course_id: 1)
Attendance.create(user_id: 36, course_id: 1)
Attendance.create(user_id: 37, course_id: 1)
Attendance.create(user_id: 38, course_id: 1)
Attendance.create(user_id: 39, course_id: 1)
Attendance.create(user_id: 40, course_id: 1)
Attendance.create(user_id: 41, course_id: 1)
Attendance.create(user_id: 42, course_id: 1)
Attendance.create(user_id: 43, course_id: 1)
Attendance.create(user_id: 44, course_id: 1)

#course2 attendances
Attendance.create(user_id: 5, course_id: 2)
Attendance.create(user_id: 6, course_id: 2)
Attendance.create(user_id: 7, course_id: 2)
Attendance.create(user_id: 8, course_id: 2)
Attendance.create(user_id: 9, course_id: 2)
Attendance.create(user_id: 10, course_id: 2)
Attendance.create(user_id: 11, course_id: 2)
Attendance.create(user_id: 12, course_id: 2)
Attendance.create(user_id: 13, course_id: 2)
Attendance.create(user_id: 14, course_id: 2)

#course3 attendances
Attendance.create(user_id: 5, course_id: 3)
Attendance.create(user_id: 6, course_id: 3)
Attendance.create(user_id: 7, course_id: 3)
Attendance.create(user_id: 8, course_id: 3)
Attendance.create(user_id: 9, course_id: 3)
Attendance.create(user_id: 10, course_id: 3)
Attendance.create(user_id: 11, course_id: 3)

#students id:5..44
exs = Course.find(1).exercises
sts = Course.find(1).students.each
exs.each do |e|
  sts.each do |s|
    randomstatus = ["green","red","yellow","gray"].sample
    if randomstatus != "gray"
      Checkmark.create(user_id: s.id, exercise_id: e.id, status: randomstatus)
    end
  end
end

exs = Course.find(2).exercises
sts = Course.find(2).students
exs.each do |e|
  sts.each do |s|
    randomstatus = ["green","red","yellow","gray"].sample
    Checkmark.create(user_id: s.id, exercise_id: e.id, status: randomstatus)
  end
end

exs = Course.find(3).exercises
sts = Course.find(3).students 
exs.each do |e|
  sts.each do |s|
    randomstatus = ["green","red","yellow","gray"].sample
    if randomstatus != "gray"
      Checkmark.create(user_id: s.id, exercise_id: e.id, status: randomstatus)
    end
  end
end





