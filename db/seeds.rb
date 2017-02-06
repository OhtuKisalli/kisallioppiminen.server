# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Course.create(coursekey: 'testikurssiavain', name: 'Testikurssi')
Course.create(coursekey: 'avain2', name: 'Rästikurssi')
User.create(username: "testaaja1", name: "Testiheppu", email:"u1@e.e", provider:nil,uid:nil,password:"qwerty")
User.create(username: "testaaja2", name: "Testaaja", email:"u2@e.e", provider:nil,uid:nil,password:"qwerty")
User.create(username: "testaaja3", name: "Testiveikko", email:"u3@e.e", provider:nil,uid:nil,password:"qwerty")
User.create(username: "batman1", name: "Batman", email:"u4@e.e", provider:nil,uid:nil,password:"qwerty")
User.create(username: "ope1", name: "Opettaja", email:"o1@e.e", provider:nil,uid:nil,password:"qwerty")
User.create(username: "ope2", name: "Reksi", email:"o2@e.e", provider:nil,uid:nil,password:"qwerty")

Attendance.create(user_id: 1, course_id: 1)
Attendance.create(user_id: 2, course_id: 1)
Attendance.create(user_id: 3, course_id: 1)
Attendance.create(user_id: 4, course_id: 1)

Attendance.create(user_id: 1, course_id: 2)
Attendance.create(user_id: 2, course_id: 2)
Attendance.create(user_id: 3, course_id: 2)
Attendance.create(user_id: 4, course_id: 2)

Teaching.create(user_id: 5, course_id: 1)
Teaching.create(user_id: 5, course_id: 2)
Teaching.create(user_id: 6, course_id: 2)

Exercise.create(html_id: "may1;1.1", course_id: 1)
Exercise.create(html_id: "may1;1.2", course_id: 1)
Exercise.create(html_id: "may1;1.3", course_id: 1)
Exercise.create(html_id: "may1;1.4", course_id: 1)
Exercise.create(html_id: "may1;1.5", course_id: 1)
Exercise.create(html_id: "may1;1.6", course_id: 1)
Exercise.create(html_id: "may1;1.7", course_id: 1)
Exercise.create(html_id: "may1;1.8", course_id: 1)
Exercise.create(html_id: "may1;1.9", course_id: 1)
Exercise.create(html_id: "may1;1.10", course_id: 1)

Exercise.create(html_id: "may1;1.1", course_id: 2)  ## id:11
Exercise.create(html_id: "may1;1.2", course_id: 2)
Exercise.create(html_id: "may1;1.3", course_id: 2)
Exercise.create(html_id: "may1;1.4", course_id: 2)
Exercise.create(html_id: "may1;1.5", course_id: 2)
Exercise.create(html_id: "may1;1.6", course_id: 2)
Exercise.create(html_id: "may1;1.7", course_id: 2)
Exercise.create(html_id: "may1;1.8", course_id: 2)
Exercise.create(html_id: "may1;1.9", course_id: 2)
Exercise.create(html_id: "may1;1.10", course_id: 2) ## id:20

#kurssi 1
Checkmark.create(user_id: 1, exercise_id: 1, status: "grey")
Checkmark.create(user_id: 1, exercise_id: 2, status: "green")
Checkmark.create(user_id: 1, exercise_id: 3, status: "red")
Checkmark.create(user_id: 1, exercise_id: 4, status: "yellow")
Checkmark.create(user_id: 1, exercise_id: 5, status: "green")
Checkmark.create(user_id: 1, exercise_id: 6, status: "grey")
Checkmark.create(user_id: 1, exercise_id: 7, status: "grey")
Checkmark.create(user_id: 1, exercise_id: 8, status: "grey")
Checkmark.create(user_id: 1, exercise_id: 9, status: "grey")
Checkmark.create(user_id: 1, exercise_id: 10, status: "grey")

Checkmark.create(user_id: 2, exercise_id: 1, status: "red")
Checkmark.create(user_id: 2, exercise_id: 2, status: "green")
Checkmark.create(user_id: 2, exercise_id: 3, status: "red")
Checkmark.create(user_id: 2, exercise_id: 4, status: "red")
Checkmark.create(user_id: 2, exercise_id: 5, status: "grey")
Checkmark.create(user_id: 2, exercise_id: 6, status: "yellow")
Checkmark.create(user_id: 2, exercise_id: 7, status: "grey")
Checkmark.create(user_id: 2, exercise_id: 8, status: "grey")
Checkmark.create(user_id: 2, exercise_id: 9, status: "grey")
Checkmark.create(user_id: 2, exercise_id: 10, status: "grey")


Checkmark.create(user_id: 3, exercise_id: 1, status: "green")
Checkmark.create(user_id: 3, exercise_id: 2, status: "green")
Checkmark.create(user_id: 3, exercise_id: 3, status: "green")
Checkmark.create(user_id: 3, exercise_id: 4, status: "red")
Checkmark.create(user_id: 3, exercise_id: 5, status: "grey")
Checkmark.create(user_id: 3, exercise_id: 6, status: "grey")
Checkmark.create(user_id: 3, exercise_id: 7, status: "yellow")
Checkmark.create(user_id: 3, exercise_id: 8, status: "grey")
Checkmark.create(user_id: 3, exercise_id: 9, status: "grey")
Checkmark.create(user_id: 3, exercise_id: 10, status: "grey")


Checkmark.create(user_id: 4, exercise_id: 1, status: "green")
Checkmark.create(user_id: 4, exercise_id: 2, status: "green")
Checkmark.create(user_id: 4, exercise_id: 3, status: "green")
Checkmark.create(user_id: 4, exercise_id: 4, status: "green")
Checkmark.create(user_id: 4, exercise_id: 5, status: "grey")
Checkmark.create(user_id: 4, exercise_id: 6, status: "grey")
Checkmark.create(user_id: 4, exercise_id: 7, status: "grey")
Checkmark.create(user_id: 4, exercise_id: 8, status: "grey")
Checkmark.create(user_id: 4, exercise_id: 9, status: "grey")
Checkmark.create(user_id: 4, exercise_id: 10, status: "grey")

#kurssi 2
Checkmark.create(user_id: 1, exercise_id: 12, status: "yellow")
Checkmark.create(user_id: 1, exercise_id: 13, status: "red")

Checkmark.create(user_id: 2, exercise_id: 11, status: "red")
Checkmark.create(user_id: 2, exercise_id: 12, status: "green")
Checkmark.create(user_id: 2, exercise_id: 14, status: "green")

Checkmark.create(user_id: 3, exercise_id: 12, status: "green")
Checkmark.create(user_id: 3, exercise_id: 13, status: "yellow")
Checkmark.create(user_id: 3, exercise_id: 14, status: "red")

Checkmark.create(user_id: 4, exercise_id: 11, status: "green")
Checkmark.create(user_id: 4, exercise_id: 12, status: "green")
Checkmark.create(user_id: 4, exercise_id: 13, status: "red")


